import 'dart:convert';
import 'dart:math';

class FileEntry {
  String name;
  int size;
  int type;
  DateTime timestamp;

  static const int FILE = 0;
  static const int DIRECTORY = 1;
  static const int UP = 2;

  FileEntry(this.name, this.size, this.type, this.timestamp);

  @override
  String toString() {
    return "$name, $type, $timestamp";
  }

  String parseSize([int decimals = 0]) {
    if (type == DIRECTORY) {
      return "";
    }
    const suffixes = ["B", "kB", "MB", "GB", "TB"];
    if (size == 0) return '0 ${suffixes[0]}';
    var i = (log(size) / log(1024)).floor();
    return "${(size / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  static List<FileEntry> parseEntries(String entries) {
    List<FileEntry> fileEntries = <FileEntry>[];
    var jsonEntries = jsonDecode(entries);
    for (var entry in jsonEntries['data']) {
      String name = entry['name'];
      int size = entry['size'];
      int type = entry['type'];
      DateTime timestamp = parseDateTime(entry['date']);
      fileEntries.add(FileEntry(name, size, type, timestamp));
    }

    return fileEntries;
  }

  static DateTime parseDateTime(var date) {
    int month = date['month'];
    int year = date['year'];
    int dayOfMonth = date['dayOfMonth'];
    int hourOfDay = date['hourOfDay'];
    int minute = date['minute'];
    int second = date['second'];

    return DateTime(year, month, dayOfMonth, hourOfDay, minute, second);
  }
}