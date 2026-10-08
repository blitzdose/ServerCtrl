import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:server_ctrl/data_storage/database/models/server.dart';
import 'package:server_ctrl/data_storage/database/storage_database.dart';
import 'package:server_ctrl/generated/l10n.dart';
import 'package:server_ctrl/main_controller.dart';
import 'package:server_ctrl/navigator_key.dart';
import 'package:server_ctrl/ui/views/splash_screen/splash_screen.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/crypto/client_key.dart';
import 'package:server_ctrl/utilities/dialogs/dialogs.dart';
import 'package:server_ctrl/utilities/http/session.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';
import 'package:server_ctrl/utilities/text_editing_controller/error_text_editing_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AddServerController extends GetxController {

  final servernameController = ErrorTextEditingController();
  final ipController = ErrorTextEditingController();
  final usernameController = ErrorTextEditingController();
  final passwordController = ErrorTextEditingController();
  final isHttps = true.obs;

  final isLoggingIn = false.obs;
  final errorMessage = "".obs;

  @override void onReady() {
    super.onReady();

    showDialogIfFirstRun();
  }

  void showDialogIfFirstRun() async {
    bool firstRun = await IsFirstRun.isFirstCall();
    if (firstRun) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(S.current.important),
              content: Text(S.current.InstallPlugin),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => launchUrl(Uri.parse("https://serverctrl.blitzdose.de/docs/intro")), child: Text(S.current.moreInfo)),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.ok))
                  ],
                )
              ]
          );
        },
      );
    }
  }


  Future<void> login() async {
    isLoggingIn(true);
    errorMessage("");
    String servername = servernameController.value.text;
    String ip = ipController.value.text;
    String username = usernameController.value.text;
    String password = passwordController.value.text;

    if (servername.isEmpty) {
      servernameController.errorMessage(S.current.thisFieldIsRequired);
    }
    if (ip.isEmpty) {
      ipController.errorMessage(S.current.thisFieldIsRequired);
    }
    if (username.isEmpty) {
      usernameController.errorMessage(S.current.thisFieldIsRequired);
    }
    if (password.isEmpty) {
      passwordController.errorMessage(S.current.thisFieldIsRequired);
    }

    if (servername.isEmpty || ip.isEmpty || username.isEmpty || password.isEmpty) {
      isLoggingIn(false);
      return;
    }

    String protocol = "http://";
    if (isHttps.isTrue) {
      protocol = "https://";
    }

    if (await BackendProvider(MyAppController.storageDatabase.database).exists(servername)) {
      errorMessage(S.current.youAlreadyAddedThisServer);
      isLoggingIn(false);
      return;
    }

    await loginProcess(servername, protocol, ip, username, password, null);
  }

  Future<void> loginProcess(String servername, String protocol, String ip, String username, String password, String? code ) async {
    Session.setBaseURL(protocol + ip);
    try {
      int loginStatusCode = await UserApi.login(username, password, code ?? "");

      if (loginStatusCode == UserApi.USER_UNAUTHORIZED) {
        errorMessage(S.current.wrongUsernameOrPassword);
      } else if (loginStatusCode == UserApi.USER_TOTP_REQUIRED) {
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
            loginProcess(servername, protocol, ip, username, password, text);
          },
        ).showInputDialog(navigatorKey.currentContext!);
      } else if (loginStatusCode == 200) {
        ClientKey clientKey = ClientKey.generate();
        if (!await UserApi.addPublicKey(base64.encode(clientKey.getPublicKeyBytes()))) {
          errorMessage(S.current.somethingWentWrong);
          isLoggingIn(false);
          return;
        }
        await UserApi.logout();

        if (!await UserApi.publicKeyLogin(username, clientKey)) {
          errorMessage(S.current.somethingWentWrong);
          isLoggingIn(false);
          return;
        }

        Backend server = Backend(servername, ip, protocol, username, clientKey);
        BackendProvider serverProvider = BackendProvider(MyAppController.storageDatabase.database);
        serverProvider.insert(server);
        serverProvider.setSelectedBackend(server);

        Snackbar.createWithTitle(S.current.newServer, S.current.newServerAdded);
        servernameController.text = "";
        ipController.text = "";
        usernameController.text = "";
        passwordController.text = "";
        isHttps(true);
        FocusManager.instance.primaryFocus?.unfocus();

        Get.offAllNamed(SplashScreenView.route);
      }
    } on SocketException catch (_) {
      errorMessage(S.current.cannotReachIp(ip));
    } on TimeoutException catch (_) {
      errorMessage(S.current.cannotReachIp(ip));
    } on HandshakeException catch (p) {
      if (p.osError != null && p.osError!.message.contains("CERTIFICATE_VERIFY_FAILED")) {
        errorMessage(S.current.acceptWarningTryAgain);
      } else {
        errorMessage(S.current.cannotReachIpOverHttps(ip));
      }
    } catch (e) {
      e.printError();
      errorMessage(S.current.somethingWentWrong);
    }
    isLoggingIn(false);
  }
}

class AddServerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddServerController());
  }
}