class SystemData {
  int totalSystemMem;
  int cpuLoad;
  int cpuCores;
  int memTotal;
  int freeSystemMem;
  int time;
  int memUsed;
  int memMax;
  List<FileSystemSpace> fileSystemSpaces;

  SystemData(this.totalSystemMem, this.cpuCores, this.cpuLoad, this.memTotal, this.freeSystemMem, this.time, this.memUsed, this.memMax, this.fileSystemSpaces);

  double cpuLoadAsDouble() {
    return cpuLoad / 100;
  }

  double memoryUsageAsDouble() {
    return (1 - (freeSystemMem / totalSystemMem)) * 100;
  }
}

class FileSystemSpace {
  String name;
  int usableSpace;
  int totalSpace;

  FileSystemSpace(this.name, this.usableSpace, this.totalSpace);
}