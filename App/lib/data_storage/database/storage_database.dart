import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:server_ctrl/data_storage/database/database_exceptions.dart';
import 'package:server_ctrl/data_storage/database/models/generic.dart';
import 'package:server_ctrl/data_storage/database/models/server.dart';
import 'package:server_ctrl/utilities/api/models/provisioning_client.dart';
import 'package:server_ctrl/utilities/crypto/encryption.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class StorageDatabase {

  late Database database;

  Future<void> open() async {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? encryptionKey = await secureStorage.read(key: "database.storage.key");
    encryptionKey ??= Encryption.generateEncryptionKey();
    await secureStorage.write(key: "database.storage.key", value: encryptionKey);
    database = await openDatabase(
      join(await getDatabasesPath(), 'storage.db'),
      password: encryptionKey,
      onCreate: (db, version) {
        return db.execute("CREATE TABLE servers(servername TEXT PRIMARY KEY, ip TEXT, protocol TEXT, username TEXT, clientKey TEXT)");
      },
      version: 1
    );
  }
}

abstract class Provider<T extends DatabaseModel> {
  Database database;
  String table;
  String primaryKey;
  T Function(Map<String, Object?> map) fromMapConstructor;

  Provider(this.database, this.table, this.primaryKey, this.fromMapConstructor);

  Future<void> insert(T t) async {
    try {
      await database.insert(table, t.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError("$table.$primaryKey")) {
        throw AlreadyExistsException();
      }
      throw UnknownException();
    }
  }

  Future<List<T>> getAll() async {
    final List<Map<String, Object?>> maps = await database.query(table);
    return maps.map((e) => fromMapConstructor(e)).toList();
  }

  Future<void> update(T t) async {
    await database.update(table, t.toMap(), where: "$primaryKey = ?", whereArgs: [t.getPrimaryKey()]);
  }

  Future<void> delete(T t) async {
    await database.delete(table, where: "$primaryKey = ?", whereArgs: [t.getPrimaryKey()]);
  }

  Future<T> find(Object key) async {
    try {
      return fromMapConstructor((await database.query(table, where: "$primaryKey = ?", whereArgs: [key])).first);
    } on StateError {
      throw NotFoundException();
    }
  }

  Future<bool> exists(Object key) async {
    var list = await database.query(table, where: "$primaryKey = ?", whereArgs: [key]);
    return list.isNotEmpty;
  }
}

class BackendProvider extends Provider<Backend> {
  BackendProvider(Database database) : super(database, "servers", "servername", (map) => Backend.fromMap(map));

  Future<void> setSelectedBackend(Backend server) async {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: "servers.selected", value: server.name);
  }

  Future<Backend?> getSelectedBackend() async {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? selectedServerName = await secureStorage.read(key: "servers.selected");
    if (selectedServerName == null) {
      return null;
    }
    try {
      return await find(selectedServerName);
    } on NotFoundException {
      return null;
    }
  }
}

class ClientProvider {
  ClientProvider();

  Future<void> setSelectedClient(String backend, String client) async {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: "servers.$backend.selectedClient", value: client);
  }

  Future<String?> getSelectedClient(String backend) async {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    return await secureStorage.read(key: "servers.$backend.selectedClient");
  }
}