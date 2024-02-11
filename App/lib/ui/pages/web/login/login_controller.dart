import 'dart:async';
import 'dart:convert';
import 'package:server_ctrl/navigator_key.dart';
import 'package:server_ctrl/utilities/dialogs/dialogs.dart';
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
          loggedIn();
        }
      });
    }  
  }

  login() {
    isLoggingIn(true);
    errorMessage("");
    String username = usernameController.value.text;
    String password = passwordController.value.text;

    if (username.isEmpty || password.isEmpty) {
      errorMessage(S.current.pleaseInputYourUsernameAndPassword);
      isLoggingIn(false);
      return;
    }
    loginProcess(username, password, null);
  }

  loginProcess(String username, String password, String? code) async {
    Session.setBaseURL("");
    var map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = base64.encode(utf8.encode(password));
    if (code != null) {
      map['code'] = code;
    }
    try {
      var response = await Session.post("/api/user/login", map);
      if (response.statusCode == 401) {
        errorMessage(S.current.wrongUsernameOrPassword);
      } else if (response.statusCode == 402) {
        InputDialog(
          title: S.current.twofactorAuthentication,
          textInputType: TextInputType.number,
          message: S.current.pleaseInputYourCode,
          inputFieldHintText: S.current.totpCode,
          inputFieldBorder: const OutlineInputBorder(),
          inputFieldLength: 6,
          inputFieldError: (code == null) ? null : S.current.wrongCode,
          rightButtonText: S.current.login,
          leftButtonText: S.current.cancel,
          onLeftButtonClick: null,
          onRightButtonClick: (text) {
            loginProcess(username, password, text);
          },
        ).showInputDialog(navigatorKey.currentContext!);

      } else if (response.statusCode == 200) {
        loggedIn();
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

  void loggedIn() {
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