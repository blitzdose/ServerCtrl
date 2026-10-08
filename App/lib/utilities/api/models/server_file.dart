import 'dart:math';

class ServerFile {
  String name;
  int size;
  bool isFile;
  int lastModified;
  String path;

  ServerFile(this.name, this.size, this.isFile, this.lastModified, this.path);

  String parsedSize([int decimals = 0]) {
    if (!isFile) {
      return "";
    }
    const suffixes = ["B", "kB", "MB", "GB", "TB"];
    if (size == 0) return '0 ${suffixes[0]}';
    var i = (log(size) / log(1024)).floor();
    return "${(size / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  DateTime parsedDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(lastModified);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServerFile &&
        other.name == name &&
        other.size == size &&
        other.isFile == isFile &&
        other.lastModified == lastModified &&
        other.path == path;
  }

  @override
  int get hashCode => Object.hash(name, size, isFile, lastModified, path);
}