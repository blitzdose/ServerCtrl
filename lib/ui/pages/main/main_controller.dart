import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utilities/http/session.dart';
import '../../../utilities/snackbar/snackbar.dart';

class MainController extends GetxController with GetTickerProviderStateMixin {

  String baseURL = "";

  MainController();

  Future<bool> init() async {
    bool success = true;
    const storage = FlutterSecureStorage();
    String? creds = await storage.read(key: baseURL);
    if (creds != null) {
      List<String> credsArr = creds.split("\n");
      String name = credsArr[0];
      String username = credsArr[1];
      String password = credsArr[2];
      try {
        http.Response response = await login(username, password);
        if (response.statusCode != 200) throw Exception();
      } on SocketException catch (p) {
        print(p);
        Snackbar.createWithTitle(name, "Cannot reach the server");
        success = false;
      } on TimeoutException catch (p) {
        print(p);
        Snackbar.createWithTitle(name, "Cannot reach the server");
        success = false;
      } on Exception catch (_) {
        Snackbar.createWithTitle(name, "Cannot connect to the server, maybe the credentials changed?");
        success = false;
      }
    } else {
      Snackbar.createWithTitle(baseURL, "Cannot find credentials to this server, please add it again");
      success = false;
    }
    return success;
  }

  Future<http.Response> login(String username, String password) async {
    Session.setBaseURL(baseURL);
    var map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = base64.encode(utf8.encode(password));
    return await Session.post("/api/user/login", map);
  }
}