import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/lazyloader/lazy_loader.dart';

import '../../../../../utilities/api/models/log_entry.dart';

class LogsController extends SubviewController {

  final List<LogEntry> logs = <LogEntry>[].obs;
  final showProgress = false.obs;

  late LazyLoader lazyLoader;

  LogsController({required super.params});

  @override
  void onInit() {
    super.onInit();
    lazyLoader = LazyLoader<LogEntry>(
        loadingFunction: (pagination) => LogApi.getLog(pagination),
        pageSize: 50,
        onLoadingChanged: (finished) => showProgress(!finished),
        onEntriesUpdated: (entries) => logs.assignAll(entries),
    );
    lazyLoader.loadNext();
  }

  @override
  void onShown() {
    super.onShown();
    params.onSetActions.call(
        [
          IconButton(
              onPressed: () {
                lazyLoader.refresh();
              },
              icon: const Icon(Icons.refresh_rounded)
          )
        ]
    );
  }

  @override
  Future<void> updateData() async {

  }
}