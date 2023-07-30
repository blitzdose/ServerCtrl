import 'package:http/http.dart' as http;

class Session {
  static Map<String, String> headers = {};

  static String _baseURL = "";

  static setBaseURL(String url) {
    _baseURL = url;
  }

  static Future<http.Response> get(String url) async {
    http.Response response = await http.get(Uri.parse(_baseURL + url), headers: headers);
    updateCookie(response);
    return response;
  }

  static Future<http.Response> post(String url, dynamic data) async {
    http.Response response = await http.post(Uri.parse(_baseURL + url), body: data, headers: headers);
    updateCookie(response);
    return response;
  }

  static void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}