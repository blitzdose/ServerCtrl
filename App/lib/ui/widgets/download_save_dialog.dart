import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:getxify/getxify.dart';
import 'package:material_ui/material_ui.dart';
import 'package:server_ctrl/ui/widgets/animated_linear_progress_indicator.dart';
import 'package:server_ctrl/utilities/callbacks/simple_stream.dart';
import 'package:server_ctrl/utilities/http/file.dart';

/// Dialog that shows the progress of [downloadFile] and, once the download has
/// finished, lets the user save the file.
///
/// It owns the progress state, listens to the download while it is open, and
/// removes the listeners when it is closed.
class DownloadSaveDialog extends StatefulWidget {
  const DownloadSaveDialog({
    super.key,
    required this.downloadFile,
    required this.filename,
    this.onSuccess,
    this.onFailed,
  });

  final DownloadFile downloadFile;

  /// File name shown in the dialog.
  final String filename;

  /// Called after the user has saved the file, once the dialog is closed.
  /// Receives the path the file was saved to.
  final void Function(String savedPath)? onSuccess;

  /// Called when the download failed (or the file wasn't found), once the
  /// dialog is closed. Receives the final status.
  final void Function(TaskStatus status)? onFailed;

  /// Opens the dialog. The returned future completes when the dialog closes
  /// (cancelled, saved or failed), not when the download finishes.
  static Future<void> show({
    required DownloadFile downloadFile,
    required String filename,
    void Function(String savedPath)? onSuccess,
    void Function(TaskStatus status)? onFailed,
  }) {
    return Get.dialog<void>(
      DownloadSaveDialog(
        downloadFile: downloadFile,
        filename: filename,
        onSuccess: onSuccess,
        onFailed: onFailed,
      ),
      barrierDismissible: false,
    );
  }

  @override
  State<DownloadSaveDialog> createState() => _DownloadSaveDialogState();
}

class _DownloadSaveDialogState extends State<DownloadSaveDialog> {
  /// Download progress from 0 to 1. Null shows an indeterminate indicator.
  double? _progress;
  TaskStatus? _status;
  bool _finished = false;
  final _subscriptions = <SimpleSubscription>[];

  DownloadFile get _download => widget.downloadFile;

  @override
  void initState() {
    super.initState();
    _subscriptions
      ..add(_download.progress.listen(_onProgress))
      ..add(_download.status.listen(_onStatus));
    unawaited(_run());
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void _onProgress(double data) {
    if (data >= 0) {
      setState(() => _progress = data);
    }
  }

  void _onStatus(TaskStatus data) {
    _status = data;
    if (data == TaskStatus.complete) {
      setState(() => _finished = true);
    }
    if (data == TaskStatus.failed || data == TaskStatus.notFound) {
      final onFailed = widget.onFailed;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      onFailed?.call(data);
    }
  }

  /// Waits for the download to end and reports the outcome through the status.
  Future<void> _run() async {
    if (await _download.success) {
      _download.status.push(TaskStatus.complete);
    } else if (mounted && _status != TaskStatus.canceled) {
      _download.status.push(TaskStatus.failed);
    }
  }

  Future<void> _cancel() async {
    setState(() => _progress = null);
    if (_status != TaskStatus.complete) {
      await _download.cancel();
    }
    await _deleteTempFile();
    Get.back();
  }

  Future<void> _save() async {
    final params = SaveFileDialogParams(
      sourceFilePath: _download.file.path,
      fileName: await _download.name,
    );

    final finalPath = await FlutterFileDialog.saveFile(params: params);

    if (finalPath != null) {
      if (mounted) {
        setState(() => _progress = null);
      }
      await _deleteTempFile();
      final onSuccess = widget.onSuccess;
      Get.back();
      onSuccess?.call(finalPath);
    }
  }

  Future<void> _deleteTempFile() async {
    if (await _download.file.exists()) {
      await _download.file.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Downloading File"),
      content: PopScope(
        canPop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.filename,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            AnimatedLinearProgressIndicator(value: _progress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("${((_progress ?? 0) * 100).toStringAsFixed(0)}%"),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _finished ? _save : null,
          child: const Text("Save"),
        ),
      ],
    );
  }
}