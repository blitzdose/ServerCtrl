import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:minecraft_server_remote/utilities/permissions/permissions.dart';
import 'dart:convert';

import '../../../utilities/http/session.dart';
import '../../../utilities/snackbar/snackbar.dart';

class MainControllerObject {
  final bool success;
  final Permissions permissions;

  MainControllerObject(this.success, this.permissions);
}

class MainController extends GetxController with GetTickerProviderStateMixin {

  String baseURL = "";

  var scrollableTabs = true.obs;

  MainController();

  Future<MainControllerObject> init() async {
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
      } on SocketException catch (_) {
        Snackbar.createWithTitle(name, "Cannot reach the server");
        success = false;
      } on TimeoutException catch (_) {
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

    var response = await getPermissions();
    var data = jsonDecode(response.body);
    List<dynamic> permission = data["permissions"];
    return MainControllerObject(success, Permissions(permission.map((e) => e.toString()).toList()));
  }

  Future<http.Response> login(String username, String password) async {
    Session.setBaseURL(baseURL);
    var map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = base64.encode(utf8.encode(password));
    return await Session.post("/api/user/login", map);
  }

  Future<http.Response> getPermissions() async {
    return Session.get("/api/user/permissions");
  }
}