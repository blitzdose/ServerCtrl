import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart' as dartio;

import 'package:http/http.dart' as http;
import 'package:server_ctrl/utilities/callbacks/simple_stream.dart';
import 'package:server_ctrl/utilities/http/file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../files/file_handler.dart';

class Session {
  static Map<String, String> headers = {};

  static String baseURL = "";

  static void setBaseURL(String url) {
    baseURL = url;
  }

  static Future<http.Response> get(String url, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    final uri = Uri.parse(baseURL + url).replace(queryParameters: queryParameters);
    http.Response response = await http.get(uri, headers: headers).timeout(timeout);
    updateCookie(response);
    return response;
  }

  static Future<DownloadFile> getFile(String url, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    return getFileFullURL(baseURL + url, queryParameters: queryParameters, timeout: timeout);
  }

  static Future<DownloadFile> getFileFullURL(String url, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final tempFile = await FileHandler.createFile(FileHandler.getRandomFilename());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? acceptedCerts = prefs.getStringList("accepted_certs");

    final task = DownloadTask(
        url: uri.toString(),
        filename: tempFile.uri.pathSegments.last,
        headers: headers,
        directory: tempFile.parent.path,
        baseDirectory: BaseDirectory.root,
        updates: Updates.statusAndProgress,
        requiresWiFi: false,
        retries: 1,
        allowPause: false,
        trustedCertificates: acceptedCerts?.map((e) => e.replaceAll(":", "")).toList(),
    );

    SimpleStream<double> progressNotifier = SimpleStream<double>();
    SimpleStream<TaskStatus> statusNotifier = SimpleStream<TaskStatus>();

    final result = FileDownloader().download(task, onProgress: (progress) {
      progressNotifier.push(progress);
    }, onStatus: (status) {
      statusNotifier.push(status);
    });

    Future<String> filename = result.then((value) {
      String filename = "file";
      String? contentDisposition = value.responseHeaders?["content-disposition"];
      if (contentDisposition != null) {
        final regex = RegExp(r'filename="?([^"]+)"?');
        final match = regex.firstMatch(contentDisposition);
        filename = match?.group(1) ?? filename;
      }
      return filename;
    },);

    return DownloadFile(filename, tempFile, progressNotifier, statusNotifier, result.then((value) => value.responseStatusCode == 200), () => FileDownloader().cancel(task));
  }

  static Future<http.Response> post(String url, dynamic data, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    http.Response response = await http.post(Uri.parse(baseURL + url).replace(queryParameters: queryParameters), body: data.toString(), headers: headers).timeout(timeout);
    updateCookie(response);
    return response;
  }

  static Future<http.Response> postCertFile(String url, Map<String, List<int>> files, {Duration timeout = const Duration(seconds: 10)}) async {
    var request = http.MultipartRequest("POST", Uri.parse(baseURL + url));
    for (var entry in headers.entries) {
      request.headers[entry.key] = entry.value;
    }
    for(var file in files.entries) {
      request.files.add(http.MultipartFile.fromBytes(file.key, file.value, filename: file.key));
    }
    var streamedResponse = await request.send().timeout(timeout);
    var response = await http.Response.fromStream(streamedResponse);
    updateCookie(response);
    return response;
  }

  static Future<http.Response> postFile(String url, UploadFile uploadFile, Function(int sent, int total, bool finished) onUploadProgress, dartio.CancelToken? cancelToken, {Map<String, dynamic>? queryParameters}) async {
    final dio = dartio.Dio();
    try {
      final uri = Uri.parse(baseURL + url).replace(
        queryParameters: queryParameters,
      );

      final response = await dio.postUri(
        uri,
        data: uploadFile.bytes,
        options: dartio.Options(
          responseType: dartio.ResponseType.plain,
          headers: {...headers, "Content-Length": uploadFile.size},
          contentType: 'application/octet-stream'
        ),
        onSendProgress: (int sent, int total) {
          final finished = sent == total;
          onUploadProgress(sent, total, finished);
        },
        cancelToken: cancelToken,
      );

      return http.Response(response.data, response.statusCode!);
    } catch (e) {
      return http.Response("", 400);
    }
  }

  static Future<http.Response> postFileFromWeb(String url, Map<String, UploadFile> files, dartio.CancelToken cancelToken, Function(int sent, int total, bool finished) onUploadProgress) async {
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

    dartio.Dio dio = dartio.Dio(options);

    Map<String, dynamic> formEntries = {};
    for(var file in files.entries) {
      //TODO: FIX ME
      //formEntries[file.key] = dartio.MultipartFile.fromBytes(file.value.bytes, filename: file.value.path);
    }

    var formData = dartio.FormData.fromMap(formEntries);

    var dioResponse = await dio.post<String>(
      baseURL + url,
      data: formData,
      cancelToken: cancelToken,
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