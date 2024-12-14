import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:server_ctrl/utilities/http/session.dart';

class OtherDownloader {
  late Function(double) onProgress;
  late Function(bool) onFinished;
  StreamSubscription? listener;
  Client? client;

  void initialize(Function(double) onProgress, Function(bool) onFinished) {
    this.onProgress = onProgress;
    this.onFinished = onFinished;
  }

  download(String url, path, fileName) async {
    var receivedLength = 0.obs;
    List<int> buffer = [];

    final Directory cacheDir = await getApplicationCacheDirectory();
    File file = File("${cacheDir.path}/$fileName");
    if (await file.exists()) {
      file.deleteSync();
    }

    var (client, stream, totalLength) = await Session.getFileFullURL(url);
    this.client = client;

    var fileOut = file.openWrite();

    listener = stream.listen((value) {
      fileOut.add(value);
      receivedLength(receivedLength.value + value.length);
      onProgress(receivedLength.value / totalLength);
    },);

    listener!.onDone(() async {
      file.writeAsBytes(buffer, mode: FileMode.append);
      client.close();
      receivedLength(totalLength);
      onFinished(true);
    });
    listener!.onError((object) {
      onFinished(false);
    });
  }

  cancel() async {
    if (listener != null) {
      listener!.cancel();
    }
    if (client != null) {
      client!.close();
    }
  }
}