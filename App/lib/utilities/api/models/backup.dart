import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:server_ctrl/values/colors.dart';

class Backup {
  String filename;
  int size;
  num percentageComplete;
  int id;
  BackupState state;
  int timestamp;

  Backup(this.filename, this.size, this.percentageComplete, this.id, this.state, this.timestamp);

  String parsedSize([int decimals = 0]) {
    const suffixes = ["B", "kB", "MB", "GB", "TB"];
    if (size == 0) return '0 ${suffixes[0]}';
    var i = (log(size) / log(1024)).floor();
    return "${(size / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  String parsedDate() {
    return DateFormat("dd. MMM yyyy HH:mm").format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  static BackupState parseBackupState(String state) {
    return BackupState.values.firstWhere((element) => element.name == state, orElse: () => BackupState.ERROR);
  }

}

enum BackupState {
  WAITING,
  RUNNING,
  FINISHED,
  ERROR;

  IconData getIcon() {
    switch (this) {
      case WAITING:
        return Icons.schedule_rounded;
      case RUNNING:
        return Icons.precision_manufacturing_rounded;
      case FINISHED:
        return Icons.done_rounded;
      case ERROR:
        return Icons.error_rounded;
    }
  }

  Color? getColor() {
    switch (this) {
      case WAITING:
      case RUNNING:
        return null;
      case FINISHED:
        return MColors.logSuccess;
      case ERROR:
        return MColors.logDanger;
    }
  }
}

enum BackupType {
  WORLD,
  FULL
}