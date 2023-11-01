import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/ui/navigation/layout_structure.dart';
import 'package:minecraft_server_remote/values/navigation_routes.dart';

import '../../../utilities/http/session.dart';
import '../../../utilities/snackbar/snackbar.dart';
import '../../navigation/nav_route.dart';
import '../main/main.dart';

class AddServerController extends GetxController {

  final ipController = TextEditingController().obs;
  final usernameController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final isHttps = true.obs;

  final isLoggingIn = false.obs;
  final errorMessage = "".obs;

  AddServerController();

  login() async {
    isLoggingIn(true);
    errorMessage("");
    String ip = ipController.value.text;
    String username = usernameController.value.text;
    String password = passwordController.value.text;

    if (ip.isEmpty || username.isEmpty || password.isEmpty) {
      errorMessage("Please input your server address, username AND password");
      isLoggingIn(false);
      return;
    }

    String protocol = "http://";
    if (isHttps.isTrue) {
      protocol = "https://";
    }

    Session.setBaseURL(protocol + ip);
    var map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = base64.encode(utf8.encode(password));
    try {
      var response = await Session.post("/api/user/login", map);
      if (response.statusCode == 401) {
        errorMessage("Wrong username or password");
      } else if (response.statusCode == 200) {
        NavigationRoutes.routes.insert(
            0,
            NavigationRoute(
                title: ip,
                icon: Icons.dns_rounded,
                route: () {return Main(Session.baseURL);}
            )
        );
        //TODO: MAKE PERSISTENT
        LayoutStructureState.navigator?.onItemTap_(0, false);
        Snackbar.createWithTitle("New server", "The new server got added successfully");
        ipController.value.text = "";
        usernameController.value.text = "";
        passwordController.value.text = "";
        isHttps(true);
      }
    } on SocketException catch (_) {
      errorMessage("Cannot reach \"$ip\"");
    } on TimeoutException catch (_) {
      errorMessage("Cannot reach \"$ip\"");
    } on HandshakeException catch (_) {
      errorMessage("Cannot reach \"$ip\" over HTTPS");
    } catch (e) {
      errorMessage("Something went wrong");
    }
    isLoggingIn(false);
  }

}