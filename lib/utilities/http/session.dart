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

  static Future<http.Response> postFile(String url, Map<String, List<int>> files) async {
    var request = http.MultipartRequest("POST", Uri.parse(_baseURL + url));
    for (var entry in headers.entries) {
      request.headers[entry.key] = entry.value;
    }
    for(var file in files.entries) {
      request.files.add(http.MultipartFile.fromBytes(file.key, file.value, filename: file.key));
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
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