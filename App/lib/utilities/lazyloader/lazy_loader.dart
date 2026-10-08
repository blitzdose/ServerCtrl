import 'package:server_ctrl/utilities/api/models/pagination.dart';

class LazyLoader<T> {
  final List<T> _entries = [];

  bool hasMore = true;
  final int pageSize;
  int _page = 0;

  bool isLoading = false;

  final Future<List<T>?> Function(Pagination pagination) loadingFunction;
  final void Function(bool finished) onLoadingChanged;
  final void Function(List<T> entries) onEntriesUpdated;

  LazyLoader({required this.loadingFunction, required this.pageSize, required this.onLoadingChanged, required this.onEntriesUpdated});

  Future<void> loadNext() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    onLoadingChanged.call(false);

    List<T>? newEntries = await loadingFunction.call(Pagination(_page * pageSize, pageSize));

    if (newEntries == null) {
      isLoading = false;
      onLoadingChanged.call(true);
      return;
    }

    _entries.addAll(newEntries);
    onEntriesUpdated(List.from(_entries));
    _page++;

    if (newEntries.length == pageSize) {
      hasMore = true;
    } else {
      hasMore = false;
    }

    isLoading = false;
    onLoadingChanged.call(true);
  }

  Future<void> refresh() async {
    hasMore = true;
    _page = 0;
    _entries.clear();
    onEntriesUpdated(List.from(_entries));
    await loadNext();
  }
}