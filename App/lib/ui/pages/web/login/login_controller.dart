import 'dart:async';
import 'dart:convert';
import 'package:universal_html/html.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/navigation/nav_route.dart';

import '../../../../generated/l10n.dart';
import '../../../../utilities/http/session.dart';
import '../../../../utilities/snackbar/snackbar.dart';
import '../../../../values/navigation_routes.dart';
import '../../../navigation/layout_structure.dart';
import '../../main/main.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final isLoggingIn = false.obs;
  final errorMessage = "".obs;

  LoginController() {
    final cookie = document.cookie;
    if (cookie == null) {
      return;
    }
    final entity = cookie.split("; ").map((item) {
      final split = item.split("=");
      return MapEntry(split[0], split[1]);
    });
    final cookieMap = Map.fromEntries(entity);
    String? token = cookieMap["token"];
    if (token != null) {
      Session.setBaseURL("");
      var response = Session.get("/api/server/data");
      response.then((value) {
        if (value.statusCode == 200) {
          logIn();
        }
      });
    }  
  }

  login() async {
    isLoggingIn(true);
    errorMessage("");
    String username = usernameController.value.text;
    String password = passwordController.value.text;

    if (username.isEmpty || password.isEmpty) {
      errorMessage(S.current.pleaseInputYourUsernameAndPassword);
      isLoggingIn(false);
      return;
    }

    Session.setBaseURL("");
    var map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = base64.encode(utf8.encode(password));
    try {
      var response = await Session.post("/api/user/login", map);
      if (response.statusCode == 401) {
        errorMessage(S.current.wrongUsernameOrPassword);
      } else if (response.statusCode == 200) {
        logIn();
        usernameController.value.text = "";
        passwordController.value.text = "";
      }
    } on SocketException catch (_) {
      errorMessage(S.current.somethingWentWrong);
    } on TimeoutException catch (_) {
      errorMessage(S.current.somethingWentWrong);
    } on HandshakeException catch (p) {
      if (p.osError != null && p.osError!.message.contains("CERTIFICATE_VERIFY_FAILED")) {
        errorMessage(S.current.acceptWarningTryAgain);
      } else {
        errorMessage(S.current.somethingWentWrong);
      }
    } catch (e) {
      e.printError();
      errorMessage(S.current.somethingWentWrong);
    }
    isLoggingIn(false);
  }

  void logIn() {
    NavigationRoutes.routes.removeAt(0);
    NavigationRoutes.routes.insert(
        0,
        NavigationRoute(
            id: Session.baseURL,
            title: "Control",
            icon: Icons.dns_rounded,
            route: () {return MainLogin.mainLogin(Session.baseURL);}
        )
    );
    LayoutStructureState.navigator?.onItemTap_(0, false);
    Snackbar.createWithTitle(S.current.server_ctrl, S.current.successfullyLoggedIn);
  }

}