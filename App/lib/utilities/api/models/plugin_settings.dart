class PluginSettings {
  bool isHTTPS;
  int port;

  PluginSettings(this.isHTTPS, this.port);

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      "Https": isHTTPS,
      "Port": port
    };
  }
}