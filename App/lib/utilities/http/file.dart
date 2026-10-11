import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:server_ctrl/utilities/callbacks/simple_stream.dart';

class UploadFile {
  String path;
  Stream<List<int>> bytes;
  int size;

  static UploadFile fromBytes(String path, List<int> bytes, int size) {
    return UploadFile(path, Stream.fromIterable([bytes]), size);
  }

  static UploadFile fromStream(String path, Stream<List<int>> bytes, int size) {
    return UploadFile(path, bytes, size);
  }

  UploadFile(this.path, this.bytes, this.size);
}

class DownloadFile {
  Future<String> name;
  File file;
  SimpleStream<double> progress;
  SimpleStream<TaskStatus> status;
  Future<bool> success;
  Future<void> Function() cancel;

  DownloadFile(this.name, this.file, this.progress, this.status, this.success, this.cancel);
}