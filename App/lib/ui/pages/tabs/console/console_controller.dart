import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:server_ctrl/utilities/api/api_utilities.dart';
import 'package:server_ctrl/utilities/http/http_utils.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../generated/l10n.dart';
import '../../../../navigator_key.dart';
import '../../../../utilities/http/session.dart';
import '../../../../values/colors.dart';
import '../../../navigation/layout_structure.dart';
import '../tab.dart';

class ConsoleController extends TabxController {

  final commandTextController = TextEditingController().obs;
  final consoleScrollController = ScrollController().obs;

  final consoleLog = <TextSpan>[].obs;

  final softwrap = true.obs;

  ConsoleController();

  @override
  void updateData() async {
    List<TextSpan> textSpans = <TextSpan>[];
    http.Response response = await fetchData();
    if (response.body.isEmpty || !HttpUtils.isSuccess(response)) {
      return;
    }
    var data = jsonDecode(response.body);
    if (data['log'].toString().isEmpty) {
      return;
    }
    formatLog(parseData(data), textSpans);
    consoleLog.value = textSpans;
    consoleLog.refresh();
  }

  @override
  Future<http.Response> fetchData() async {
    return await Session.get("/api/console/log");
  }

  String parseData(data) {
    String log = data['log'];
    if (log.length > 20000) {
      log = log.substring(log.length-20000);
    }

    return log;
  }

  void formatLog(String log, List<TextSpan> textSpansFinal) {
    List<TextSpan> textSpans = [];
    List<String> logLines = log.split(newlineRegExp);
    for(String logLine in logLines)  {
      if (logLine.contains(RegExp(r"\[\d\d:\d\d:\d\d WARN\]"))) {
        textSpans.add(TextSpan(text: logLine.replaceAll(RegExp(r"!_/[a-f0-9]"), ""), style: const TextStyle(color: MColors.minecraftYellow)));
        textSpans.add(const TextSpan(text: "\n"));
        continue;
      } else if (logLine.contains(RegExp(r"\[\d\d:\d\d:\d\d ERROR\]"))) {
        textSpans.add(TextSpan(text: logLine.replaceAll(RegExp(r"!_/[a-f0-9]"), ""), style: const TextStyle(color: MColors.minecraftRed)));
        textSpans.add(const TextSpan(text: "\n"));
        continue;
      }
      List<String> parts = logLine.split("!_/");
      for(int i=0; i<parts.length; i++) {
        String part = parts[i];
        if (i>0) {
          String color = part.substring(0, 1);
          part = part.substring(1);
          TextStyle textStyle = const TextStyle(color: Colors.white);
          switch(color) {
            case "0":
              textStyle = const TextStyle(color: MColors.minecraftBlack);
              break;
            case "1":
              textStyle = const TextStyle(color: MColors.minecraftDarkBlue);
              break;
            case "2":
              textStyle = const TextStyle(color: MColors.minecraftDarkGreen);
              break;
            case "3":
              textStyle = const TextStyle(color: MColors.minecraftDarkAqua);
              break;
            case "4":
              textStyle = const TextStyle(color: MColors.minecraftDarkRed);
              break;
            case "5":
              textStyle = const TextStyle(color: MColors.minecraftDarkPurple);
              break;
            case "6":
              textStyle = const TextStyle(color: MColors.minecraftGold);
              break;
            case "7":
              textStyle = const TextStyle(color: MColors.minecraftGray);
              break;
            case "8":
              textStyle = const TextStyle(color: MColors.minecraftDarkGray);
              break;
            case "9":
              textStyle = const TextStyle(color: MColors.minecraftBlue);
              break;
            case "a":
              textStyle = const TextStyle(color: MColors.minecraftGreen);
              break;
            case "b":
              textStyle = const TextStyle(color: MColors.minecraftAqua);
              break;
            case "c":
              textStyle = const TextStyle(color: MColors.minecraftRed);
              break;
            case "d":
              textStyle = const TextStyle(color: MColors.minecraftLitPurple);
              break;
            case "e":
              textStyle = const TextStyle(color: MColors.minecraftYellow);
              break;
            case "f":
              textStyle = const TextStyle(color: MColors.minecraftWhite);
              break;
          }
          textSpans.add(TextSpan(text: part, style: textStyle));
        } else {
          textSpans.add(TextSpan(text: part, style: const TextStyle(color: Colors.white)));
        }
      }
      textSpans.add(const TextSpan(text: "\n"));
    }
    for(TextSpan span in textSpans) {
      for(String word in span.text!.split(" ")) {
        if (_isLink(word)) {
          textSpansFinal.add(TextSpan(
              text: word,
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (await canLaunchUrlString(word)) {
                    await launchUrlString(word);
                  }
                }
          ));
        } else {
          textSpansFinal.add(TextSpan(text: word, style: span.style));
        }
        textSpansFinal.add(TextSpan(text: " ", style: span.style));
      }
      textSpansFinal.removeLast();
    }
  }

  bool _isLink(String s) {
    final urlRegExp = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    return urlRegExp.hasMatch(s);
  }

  void handleSend(String value, context) async {
    FocusScope.of(context).unfocus();
    commandTextController.value.clear();

    if (!await ApiUtilities.sendCommand(value)) {
      Snackbar.createWithTitle(S.current.console, S.current.error_sending_command, true);
    }
    updateData();
  }

  @override
  void setAction() {
    LayoutStructureState.controller.actions.clear();
    LayoutStructureState.controller.actions.add(
        IconButton(
            onPressed: () {
              showDialog(
                context: navigatorKey.currentContext!,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(S.current.power),
                      content: Text(S.current.restartInfo),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: () async {
                              Navigator.pop(context);
                              http.Response response = await Session.post("/api/server/stop", null);
                              if (HttpUtils.isSuccess(response)) {
                                Snackbar.createWithTitle(S.current.server, S.current.serverStoppedSuccessfully);
                              }  else {
                                Snackbar.createWithTitle(S.current.files, S.current.errorWhileStoppingServer, true);
                              }
                            }, child: Text(S.current.stopServer)),
                            TextButton(onPressed: () async {
                              Navigator.pop(context);
                              http.Response response = await Session.post("/api/server/restart", null);
                              if (HttpUtils.isSuccess(response)) {
                                Snackbar.createWithTitle(S.current.server, S.current.serverRestartedSuccessfully);
                              }  else {
                                Snackbar.createWithTitle(S.current.files, S.current.errorWhileRestartingServer, true);
                              }
                            }, child: Text(S.current.restartServer))
                          ],
                        )
                      ]
                  );
                },
              );
            },
            icon: const Icon(Icons.power_settings_new_rounded)
        )
    );
    LayoutStructureState.controller.actions.add(
        IconButton(
            onPressed: () {
              showDialog(
                context: navigatorKey.currentContext!,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(S.current.reload),
                      content: Text(S.current.reloadInfo),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: () async {
                              Navigator.pop(context);
                              http.Response response = await Session.post("/api/server/reload", null);
                              if (HttpUtils.isSuccess(response)) {
                                Snackbar.createWithTitle(S.current.server, S.current.serverReloadSuccessfully);
                              }  else {
                                Snackbar.createWithTitle(S.current.files, S.current.errorWhileReloadingServer, true);
                              }
                            }, child: Text(S.current.reloadServer)),
                          ],
                        )
                      ]
                  );
                },
              );
            },
            icon: const Icon(Icons.refresh_rounded)
        )
    );
    LayoutStructureState.controller.actions.add(
        PopupMenuButton(
          padding: EdgeInsets.zero,
          onSelected: (value) {
            if (value == 0) {
              softwrap(softwrap.isFalse);
            }
          },
          itemBuilder: (context) => [
            CheckedPopupMenuItem(
              padding: EdgeInsets.zero,
              checked: softwrap.value,
              value: 0,
              child: const Text("Soft-wrap"),
            )
          ],
        )
    );
  }
}