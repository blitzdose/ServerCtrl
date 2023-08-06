import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:minecraft_server_remote/utilities/api/api_utilities.dart';
import 'package:minecraft_server_remote/utilities/http/http_utils.dart';
import 'package:minecraft_server_remote/utilities/snackbar/snackbar.dart';

import '../../../../generated/l10n.dart';
import '../../../../utilities/http/session.dart';
import '../../../../values/colors.dart';

class ConsoleController extends GetxController {

  final commandTextController = TextEditingController().obs;
  final consoleScrollController = ScrollController().obs;

  final consoleLog = <TextSpan>[].obs;

  static Timer? timer;

  ConsoleController();

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

  void formatLog(String log, List<TextSpan> textSpans) {
    List<String> logLines = log.split(newlineRegExp);
    for(String logLine in logLines)  {
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
          textSpans.add(TextSpan(text: part));
        }
      }
      textSpans.add(const TextSpan(text: "\n"));
    }
  }

  void handleSend(String value, context) async {
    FocusScope.of(context).unfocus();
    commandTextController.value.clear();

    if (!await ApiUtilities.sendCommand(value)) {
      Snackbar.createWithTitle(S.current.console, S.current.error_sending_command, true);
    }
    updateData();
  }

  void cancelTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  void continueTimer() {
    if (timer == null || !timer!.isActive) {
      updateData();
      timer = Timer.periodic(const Duration(seconds: 5), (timer) => updateData());
    }
  }
}