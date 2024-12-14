import 'package:flutter/material.dart';
import 'package:server_ctrl/generated/l10n.dart';

class BackupState {
  String fileName;
  double percentageComplete;
  int id;
  BackupStateState state;
  String date;
  int timestamp;
  int size;

  BackupState(this.id, this.fileName, this.percentageComplete, this.state, this.date, this.timestamp, this.size);
}

enum BackupStateState {
  WAITING, RUNNING, FINISHED, ERROR;

  static BackupStateState parseState(String state) {
    switch (state) {
      case "WAITING":
        return BackupStateState.WAITING;
      case "RUNNING":
        return BackupStateState.RUNNING;
      case "FINISHED":
        return BackupStateState.FINISHED;
      default:
        return BackupStateState.ERROR;
    }
  }

  String getLocalizedName() {
    switch (this) {
      case BackupStateState.WAITING:
        return S.current.waiting;
      case BackupStateState.RUNNING:
        return S.current.running;
      case BackupStateState.FINISHED:
        return S.current.finished;
      case BackupStateState.ERROR:
        return S.current.error;
    }
  }

  IconData getIcon() {
    switch (this) {
      case BackupStateState.WAITING:
        return Icons.schedule_rounded;
      case BackupStateState.RUNNING:
        return Icons.precision_manufacturing_rounded;
      case BackupStateState.FINISHED:
        return Icons.done_rounded;
      case BackupStateState.ERROR:
        return Icons.error_rounded;
    }
  }

}