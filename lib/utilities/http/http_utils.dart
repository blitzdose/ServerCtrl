import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpUtils {
  static bool isSuccess(http.Response? response) {
    if (response == null || response.statusCode != 200) {
      return false;
    }
    try {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['success'];
    } on Exception catch (_) {
      return false;
    }
  }
}