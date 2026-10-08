import 'dart:convert';

import 'package:server_ctrl/data_storage/database/models/generic.dart';
import 'package:server_ctrl/utilities/crypto/client_key.dart';

class Backend extends DatabaseModel {

  String name;
  String ip;
  String protocol;
  String username;
  ClientKey clientKey;

  Backend(this.name, this.ip, this.protocol, this.username, this.clientKey);

  Backend.fromMap(Map<String, Object?> map) :
        name = map["servername"] as String,
        ip = map["ip"] as String,
        protocol = map["protocol"] as String,
        username = map["username"] as String,
        clientKey = ClientKey.fromMap(jsonDecode(map["clientKey"] as String) as Map<String, dynamic>);

  @override
  Map<String, Object?> toMap() {
    return {"servername": name, "ip": ip, "protocol": protocol, "username": username, "clientKey": jsonEncode(clientKey.toMap())};
  }

  @override
  String toString() {
    return "Server(servername: $name, ip: $ip, protocol: $protocol, username: $username, clientKey: $clientKey)";
  }

  @override
  Object getPrimaryKey() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Backend &&
        other.name == name &&
        other.ip == ip &&
        other.protocol == protocol &&
        other.username == username;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      ip,
      protocol,
      username
    );
  }

}