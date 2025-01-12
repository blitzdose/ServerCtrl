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

  static Future<ServerType> getServerType() async {
    http.Response response = await Session.get("/api/server/data");
    if (HttpUtils.isSuccess(response)) {
      var data = jsonDecode(response.body);
      String type = data["data"]["type"];
      return ServerType.parse(type);
    }
    return ServerType.SPIGOT;
  }
}

enum ServerType {
  BUNGEE,
  VELOCITY,
  SPIGOT;

  static ServerType parse(String s) {
    switch(s.toUpperCase()) {
      case("BUNGEE"):
        return ServerType.BUNGEE;
      case ("SPIGOT"):
        return ServerType.SPIGOT;
      case("VELOCITY"):
        return ServerType.VELOCITY;
      default:
        return ServerType.SPIGOT;
    }
  }
}