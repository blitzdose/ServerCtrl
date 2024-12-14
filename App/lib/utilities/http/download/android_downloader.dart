import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AndroidDownloader {
  static const _channel = MethodChannel('de.blitzdose.serverctrl/downloader');

  int? id;

  bool isFinished = false;
  bool isError = false;

  void initialize(Function(double) onProgressFunc, Function(bool) onFinished) {
    _channel.setMethodCallHandler((call) {
      if (call.method == 'notifyProgress') {
        String status = call.arguments["status"];
        if (status == "Finished") {
          isFinished = true;
          onFinished(true);
        }
        if (status == "Error") {
          isError = true;
          onFinished(false);
        }

        onProgressFunc(call.arguments["progress"]);
      }
      return Future.value(null);
    });
  }

  download(url, path, fileName, headers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? acceptedCerts = prefs.getStringList("accepted_certs");
    id = await _channel.invokeMethod<int>("download", <String, dynamic>{
      'url':  url,
      'path': path,
      'fileName': fileName,
      'headers': headers,
      'accepted_certs': acceptedCerts?.map((e) => e.replaceAll(":", "")).toList()
    });
  }

  cancel() async {
    await _channel.invokeListMethod("cancel", <String, dynamic>{
      'id': id
    });
  }
}