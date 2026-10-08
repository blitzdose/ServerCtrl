class LogEntry {
  String timestamp;
  String type;
  String message;

  static const String LOGIN_FAILED = "[Login failed]";
  static const String LOGIN_SUCCESSFULLY = "[Login Successfully]";
  static const String PLAYER_JOIN = "[Player join]";
  static const String PLAYER_QUIT = "[Player quit]";

  LogEntry(this.timestamp, this.type, this.message);

  @override
  String toString() {
    return "$timestamp, $type, $message";
  }

  static List<LogEntry> parseLog(String entries) {
    List<LogEntry> logEntries = <LogEntry>[];
    List<String> logLines = entries.split("\n");
    for (String logLine in logLines) {
      RegExp pattern = RegExp("(\\[\\d\\d\\.\\d\\d\\.\\d\\d \\d\\d:\\d\\d:\\d\\d]) (\\[.+?]) (.*)");
      RegExpMatch? match = pattern.firstMatch(logLine);
      if (match != null) {
        String timestamp = match.group(1)!;
        String type = match.group(2)!;
        String message = match.group(3)!;
        LogEntry logEntry = LogEntry(timestamp, type, message);
        logEntries.add(logEntry);
      }
    }
    return logEntries;
  }
}