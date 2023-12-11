import 'dart:convert';

import 'package:http/http.dart' as http;
import '../http/http_utils.dart';
import '../http/session.dart';

class ApiUtilities {

  static Future<bool> sendCommand(String command) async {
    String commandBase64 = const Base64Encoder.urlSafe().convert(utf8.encode(command)).trim();
    http.Response response = await Session.post("/api/console/command", "{\"command\": \"$commandBase64\"}");
    if (!HttpUtils.isSuccess(response)) {
      return false;
    }
    return true;
  }
}