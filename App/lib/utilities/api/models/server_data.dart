class ServerData {
  bool onlineMode;
  String motd;
  bool hasWhitelist;
  int maxPlayers;
  bool allowEnd;
  int port;
  bool allowNether;
  bool allowCommandBlock;
  ServerType type;
  String version;

  ServerData(this.onlineMode, this.motd, this.hasWhitelist, this.maxPlayers, this.allowEnd, this.port, this.allowNether, this.allowCommandBlock, this.type, this.version);

  static ServerType parsePermission(String serverType) {
    return ServerType.values.firstWhere((element) => element.name == serverType, orElse: () => ServerType.SPIGOT);
  }
}

enum ServerType {
  BUNGEE,
  SPIGOT,
  VELOCITY
}