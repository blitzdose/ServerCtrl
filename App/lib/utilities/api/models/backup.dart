class Backup {
  String filename;
  int size;
  double percentageComplete;
  int id;
  BackupState state;
  int timestamp;

  Backup(this.filename, this.size, this.percentageComplete, this.id, this.state, this.timestamp);

  static BackupState parseBackupState(String state) {
    return BackupState.values.firstWhere((element) => element.name == state, orElse: () => BackupState.ERROR);
  }

}

enum BackupState {
  WAITING,
  RUNNING,
  FINISHED,
  ERROR
}