class LogEntry {
  late LogEntryType type;
  String line;

  LogEntry(this.line) {
    type = LogEntryType.values.firstWhere(
          (type) => line.contains(type.serialized),
      orElse: () => LogEntryType.UNKNOWN,
    );
    line = line.replaceAll("${type.serialized} ", "");
    line = "${type.serialized}\n$line";
  }
}

enum LogEntryType {
  LOGIN_SUCCESS("[Login Successfully]"),
  LOGIN_FAIL("[Login failed]"),
  COMMAND_SEND("[Command send]"),
  DOWNLOADED_FILES("[Downloaded File(s)]"),
  UPLOADED_FILES("[Uploaded File(s)]"),
  UNKNOWN("");

  final String serialized;
  const LogEntryType(this.serialized);
}