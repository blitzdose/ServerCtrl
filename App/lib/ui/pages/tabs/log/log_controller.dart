import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:server_ctrl/ui/navigation/layout_structure.dart';
import 'package:server_ctrl/ui/pages/tabs/log/log_entry.dart';
import 'package:server_ctrl/ui/pages/tabs/tab.dart';
import 'package:server_ctrl/utilities/http/http_utils.dart';
import 'package:server_ctrl/utilities/http/session.dart';
import 'package:server_ctrl/values/colors.dart';

class LogController extends TabxController {
  final logEntries = <Widget>[].obs;
  int position = 0;
  final logScrollController = ScrollController().obs;

  bool updating = false;
  
  LogController() {
    logScrollController.value.addListener(() {
      if (logScrollController.value.position.extentAfter < 200) {
        updateData();
      }
    });
  }
  
  @override
  Future<http.Response> fetchData() {
    return Session.post("/api/log/log", "{\"limit\": 50, \"position\": $position}}");
  }

  @override
  void updateData([bool reset = false]) async {
    if (reset) {
      position = 0;
    }
    var response = await fetchData();
    List<Widget> logEntriesTmp = [];
    if (HttpUtils.isSuccess(response)) {
      List<LogEntry> entries = LogEntry.parseLog(jsonDecode(response.body)['log']);
      for(LogEntry logEntry in entries) {
        logEntriesTmp.add(createListItem(logEntry));
      }
      showProgress(false);
    }
    if (reset) {
      logEntries.clear();
    }
    logEntries.addAll(logEntriesTmp);
    position = logEntries.length;
  }

  Widget createListItem(LogEntry logEntry) {
    Color textColor;
    switch(logEntry.type) {
      case LogEntry.LOGIN_SUCCESSFULLY:
        textColor = MColors.logSuccess;
        break;
      case LogEntry.LOGIN_FAILED:
        textColor = MColors.logDanger;
        break;
      case LogEntry.PLAYER_JOIN:
      case LogEntry.PLAYER_QUIT:
        textColor = MColors.logInfo;
        break;
      default:
        textColor = MColors.logWarn;
        break;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text("${logEntry.timestamp} ${logEntry.type} ${logEntry.message}", style: TextStyle(color: textColor)),
    );
  }

  @override
  void setAction() {
    LayoutStructureState.controller.actions.clear();
    LayoutStructureState.controller.actions.add(IconButton(
        onPressed: () {
          showProgress(true);
          updateData(true);
        },
        icon: const Icon(Icons.refresh_rounded)
    ));
  }

  @override
  void continueTimer() {
    updateData(true);
  }
  @override
  void cancelTimer() {}
  
}