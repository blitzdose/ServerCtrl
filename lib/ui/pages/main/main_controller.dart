import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utilities/http/session.dart';

class MainController extends GetxController with GetTickerProviderStateMixin {

  String baseURL = "";

  MainController();

  void init() async {
    http.Response response = await login();
  }

  Future<http.Response> login() async {
    Session.setBaseURL(baseURL);
    var map = <String, dynamic>{};
    map['username'] = "admin";
    map['password'] = base64.encode(utf8.encode("123"));
    return await Session.post("/api/user/login", map);
    //return await Session.get("http://192.168.2.108:5718/api/system/data");
  }
}