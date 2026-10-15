import 'dart:convert';

import 'package:server_ctrl/utilities/api/models/backup.dart';
import 'package:server_ctrl/utilities/api/models/challenge.dart';
import 'package:server_ctrl/utilities/api/models/permission.dart';
import 'package:server_ctrl/utilities/api/models/player.dart';
import 'package:server_ctrl/utilities/api/models/plugin_settings.dart';
import 'package:server_ctrl/utilities/api/models/provisioning_client.dart';
import 'package:server_ctrl/utilities/api/models/server_data.dart';
import 'package:server_ctrl/utilities/api/models/server_file.dart';
import 'package:server_ctrl/utilities/api/models/system_data.dart';
import 'package:server_ctrl/utilities/api/models/world.dart';

class ApiAdapter {
  static UserPermissions userPermissions(Map<String, dynamic> data) {
    Map<String, List<Permission>> systemPermissions = (data["permissions"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, (value as List<dynamic>).map((e) => UserPermissions.parsePermission(e as String),).toList()));
    return UserPermissions(data["superAdmin"], systemPermissions);
  }

  static PluginSettings pluginSettings(Map<String, dynamic> data) {
    return PluginSettings(data["Https"], data["Port"]);
  }

  static ProvisioningClient provisioningClient(Map<String, dynamic> data) {
    return ProvisioningClient(data["name"], data["pending"], data["lastConnected"]);
  }

  static World world(Map<String, dynamic> data) {
    return World(data["name"], data["uuid"]);
  }

  static Backup backup(Map<String, dynamic> data) {
    BackupState state = Backup.parseBackupState(data["state"]);
    return Backup(data["fileName"], data["size"], data["percentageComplete"], data["id"], state, data["timestamp"]);
  }

  static Player player(Map<String, dynamic> data) {
    return Player(data["name"], data["isOp"], data["uuid"], data["textureLink"]);
  }

  static ServerData serverData(Map<String, dynamic> data) {
    ServerType serverType = ServerData.parsePermission(data["type"]);
    return ServerData(data["onlineMode"], data["motd"], data["hasWhitelist"], data["maxPlayers"], data["allowEnd"], data["port"], data["allowNether"], data["allowCommandBlock"], serverType, data["version"]);
  }

  static SystemData systemData(Map<String, dynamic> data) {
    Map<String, dynamic> fileSystemSpacesMap = data["fileSystemSpaces"];

    List<FileSystemSpace> fileSystemSpaces = [];
    for (MapEntry<String, dynamic> entry in fileSystemSpacesMap.entries) {
      fileSystemSpaces.add(FileSystemSpace(entry.key, entry.value["freeSpace"], entry.value["totalSpace"]));
    }

    fileSystemSpaces.sort((a, b) => a.name.compareTo(b.name));

    return SystemData(data["totalSystemMem"], data["cpuCores"], data["cpuLoad"], data["memTotal"], data["freeSystemMem"], data["time"], data["memUsed"], data["memMax"], fileSystemSpaces);
  }

  static ServerFile serverFile(Map<String, dynamic> data) {
    return ServerFile(data["name"], data["size"], data["isFile"], data["lastModified"], data["path"]);
  }

  static Challenge challenge(Map<String, dynamic> data) {
    return Challenge(data["id"], base64Decode(data["nonce"]).toList());
  }
}