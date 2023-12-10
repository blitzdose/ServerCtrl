import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dartio;

import 'package:http/http.dart' as http;

class Session {
  static Map<String, String> headers = {};

  static String baseURL = "";

  static setBaseURL(String url) {
    baseURL = url;
  }

  static Future<http.Response> get(String url) async {
    http.Response response = await http.get(Uri.parse(baseURL + url), headers: headers);
    updateCookie(response);
    return response;
  }

  static Future<(http.ByteStream, int)> getFile(String url) async {
    var client = http.Client();
    http.Request request = http.Request('GET', Uri.parse(baseURL + url));
    request.headers.addAll(headers);

    var response = await client.send(request);
    var totalLength = response.contentLength ?? 0;

    return (response.stream, totalLength);
  }

  static Future<http.Response> post(String url, dynamic data) async {
    http.Response response = await http.post(Uri.parse(baseURL + url), body: data, headers: headers).timeout(const Duration(seconds: 10));
    updateCookie(response);
    return response;
  }

  static Future<http.Response> postCertFile(String url, Map<String, List<int>> files) async {
    var request = http.MultipartRequest("POST", Uri.parse(baseURL + url));
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

  static Future<http.Response> postFile(String url, String path, Map<String, String> files, Function(int, int, bool, EventSink<List<int>>) onUploadProgress) async {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(baseURL + url));
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    var multipartRequest = http.MultipartRequest("POST", Uri.parse("uri"));
    for (var entry in headers.entries) {
      multipartRequest.headers[entry.key] = entry.value;
    }
    for(var file in files.entries) {
      multipartRequest.files.add(await http.MultipartFile.fromPath(file.key, file.value, filename: file.key));
    }
    multipartRequest.fields['path'] = path;

    var msStream = multipartRequest.finalize();
    var totalLength = multipartRequest.contentLength;
    request.contentLength = totalLength;
    var byteCount = 0;

    request.headers.set(HttpHeaders.contentTypeHeader, multipartRequest.headers[HttpHeaders.contentTypeHeader]!);


    Stream<List<int>> streamUpload = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);
          byteCount += data.length;
          onUploadProgress(byteCount, totalLength, false, sink);
        },
        handleDone: (sink) {
          onUploadProgress(byteCount, totalLength, true, sink);
          sink.close();
        },
      ),
    );

    await request.addStream(streamUpload);
    final httpResponse = await request.close();
    final response = http.Response(await _readResponseAsString(httpResponse), httpResponse.statusCode);
    return response;
  }

  static Future<http.Response> postFileFromWeb(String url, String path, Map<String, Uint8List> files, Function(int, int, bool) onUploadProgress) async {
    dartio.BaseOptions options = dartio.BaseOptions(
        contentType: "multipart/form-data",
        headers: headers,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        followRedirects: true,
        validateStatus: (status) {
          return true;
        });

    dartio.Dio _dio = dartio.Dio(options);

    Map<String, dynamic> formEntries = {};
    for(var file in files.entries) {
      formEntries[file.key] = dartio.MultipartFile.fromBytes(file.value, filename: file.key);
    }

    formEntries["path"] = path;

    var formData = dartio.FormData.fromMap(formEntries);

    var dioResponse = await _dio.post<String>(
      baseURL + url,
      data: formData,
      onSendProgress: (int sent, int total) {
        onUploadProgress(sent, total, sent == total);
      },
    );
    final response = http.Response(dioResponse.data.toString(), dioResponse.statusCode!);
    return response;
  }

  static Future<String> _readResponseAsString(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  static void updateCookie(http.Response response) async {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}