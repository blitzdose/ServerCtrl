import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:server_ctrl/utilities/callbacks/simple_stream.dart';

class UploadFile {
  String path;
  List<int> bytes;
  int size;

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