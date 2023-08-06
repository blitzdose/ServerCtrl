import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:minecraft_server_remote/ui/navigation/layout_structure.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/log/log_entry.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/tab.dart';
import 'package:minecraft_server_remote/utilities/http/http_utils.dart';
import 'package:minecraft_server_remote/utilities/http/session.dart';
import 'package:minecraft_server_remote/values/colors.dart';

class LogController extends LayoutTab {
  final logEntries = <Widget>[].obs;
  final logScrollController = ScrollController().obs;
  
  LogController() {
    logScrollController.value.addListener(() {
      if (logScrollController.value.position.extentAfter < 200) {
        updateData();
      }
    });
  }
  
  @override
  Future<http.Response> fetchData() {
    return Session.post("/api/log/log", "{\"limit\": 50, \"position\": ${logEntries.length}}");
  }

  @override
  void updateData([bool reset = false]) async {
    if (reset) {
      logEntries.clear();
    }
    var response = await fetchData();
    if (HttpUtils.isSuccess(response)) {
      List<LogEntry> entries = LogEntry.parseLog(response.body);
      for(LogEntry logEntry in entries) {
        logEntries.add(createListItem(logEntry));
      }
      showProgress(false);
    }
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
    LayoutStructureState.controller.action(IconButton(
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