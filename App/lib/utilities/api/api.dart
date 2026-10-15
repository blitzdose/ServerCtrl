import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:http/src/response.dart';
import 'package:server_ctrl/utilities.old/http/http_utils.dart';
import 'package:server_ctrl/utilities/api/api_adapter.dart';
import 'package:server_ctrl/utilities/api/models/log_entry.dart';
import 'package:server_ctrl/utilities/api/models/permission.dart';
import 'package:server_ctrl/utilities/api/models/plugin_certificate.dart';
import 'package:server_ctrl/utilities/api/models/plugin_settings.dart';
import 'package:server_ctrl/utilities/crypto/client_key.dart';
import 'package:server_ctrl/utilities/http/file.dart';
import 'package:server_ctrl/utilities/http/session.dart';


import 'models/backup.dart';
import 'models/challenge.dart';
import 'models/pagination.dart';
import 'models/player.dart';
import 'models/provisioning_client.dart';
import 'models/server_data.dart';
import 'models/server_file.dart';
import 'models/system_data.dart';
import 'models/world.dart';

class _API {
  static Future<T?> get<T>(String path, {T Function(Map<String, dynamic> data)? adapter, Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    Response response;
    try {
      response = await Session.get(path, queryParameters: queryParameters, timeout: timeout);
    } on TimeoutException {
      return null;
    }
    if (HttpUtils.isSuccess(response)) {
      var jsonResponse = jsonDecode(response.body);
      if (adapter != null && jsonResponse["data"] is Map<String, dynamic>) {
        return adapter(jsonResponse["data"]);
      }
      if (jsonResponse["data"] is T) {
        return jsonResponse["data"] as T;
      }
    }
    return null;
  }

  static Future<List<T>?> getList<T>(String path, {T Function(Map<String, dynamic> data)? adapter, Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    Response response;
    try {
      response = await Session.get(path, queryParameters: queryParameters, timeout: timeout);
    } on TimeoutException {
      return null;
    }
    if (HttpUtils.isSuccess(response)) {
      var jsonResponse = jsonDecode(response.body);
      if (adapter != null && jsonResponse["data"] is List<dynamic>) {
        List<T> list = [];
        for (dynamic listEntry in jsonResponse["data"]) {
          list.add(adapter(listEntry));
        }
        return list;
      }
      if (jsonResponse["data"] is List<dynamic>) {
        return (jsonResponse["data"] as List<dynamic>).cast<T>();
      }
    }
    return null;
  }

  static Future<DownloadFile?> getFile(String path, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    try {
      return await Session.getFile(path, queryParameters: queryParameters, timeout: timeout);
    } on TimeoutException {
      return null;
    }
  }

  static Future<T?> post<T>(String path, dynamic data, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    Response response;
    try {
      response = await Session.post(path, json.encode({"data": data}), queryParameters: queryParameters, timeout: timeout);
    } on TimeoutException {
      return null;
    }
    if (HttpUtils.isSuccess(response)) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["data"] is T) {
        return jsonResponse["data"] as T;
      }
    }
    return null;
  }

  static Future<bool> postNoReturn(String path, dynamic data, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    try {
      var response = await Session.post(path, json.encode({"data": data}), queryParameters: queryParameters, timeout: timeout);
      return HttpUtils.isSuccess(response);
    } on TimeoutException {
      return false;
    }
  }

  static Future<int> postReturnStatus(String path, dynamic data, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    try {
      var response = await Session.post(path, json.encode({"data": data}), queryParameters: queryParameters, timeout: timeout);
      return response.statusCode;
    } on TimeoutException {
      return 502;
    }
  }
}

class UserApi {

  static final int USER_UNAUTHORIZED = 401;
  static final int USER_TOTP_REQUIRED = 402;

  static String _path(String path) {
    return "/api/user/$path";
  }

  static Future<int> login(String username, String password, String code) async {
    Map<String, dynamic> data = {
      "username": username,
      "password": base64Encode(utf8.encode(password)),
      "code": code
    };
    return await _API.postReturnStatus(_path("login"), data);
  }

  static Future<bool> publicKeyLogin(String username, ClientKey clientKey) async {
    Challenge? challenge = await _API.get<Challenge>(_path("challenge"), adapter: ApiAdapter.challenge);
    if (challenge == null) return false;

    Map<String, dynamic> data = {
      "username": username,
      "publicKeyHash": base64Encode(clientKey.getPublicKeyHash()),
      "challengeId": challenge.id,
      "signature": base64Encode(clientKey.signNonce(challenge.nonce))
    };

    return await _API.postNoReturn(_path("pubkeylogin"), data);
  }

  static Future<bool> addPublicKey(String base64PublicKey) async {
    return await _API.postNoReturn(_path("pubkey"), base64PublicKey);
  }

  static Future<int> changePassword(String password, String newPassword, String code) async {
    Map<String, dynamic> data = {
      "password": base64Encode(utf8.encode(password)),
      "newPassword": base64Encode(utf8.encode(newPassword)),
      "code": code
    };
    return await _API.postReturnStatus(_path("password"), data);
  }

  static Future<bool> logout() async {
    bool status = await _API.postNoReturn(_path("logout"), null);
    Session.headers = {};
    return status;
  }

  static Future<int> removeTOTP(String password, String code) async {
    Map<String, dynamic> data = {
      "password": base64Encode(utf8.encode(password)),
      "code": code
    };
    return await _API.postReturnStatus(_path("removetotp"), data);
  }

  static Future<String?> initializeTOTP(String password) async {
    return await _API.post<String>(_path("inittotp"), base64Encode(utf8.encode(password)));
  }

  static Future<bool> verifyTOTP(String code) async {
    return await _API.postNoReturn(_path("verifytotp"), code);
  }

  static Future<String?> getUsername() async {
    return await _API.get<String>(_path("current"));
  }

  static Future<UserPermissions?> getPermissions() async {
    return await _API.get<UserPermissions>(_path("permissions"), adapter: ApiAdapter.userPermissions);
  }

  static Future<bool?> hasTOTP() async {
    return await _API.get<bool>(_path("hastotp"));
  }
}

class PluginApi {

  static String _path(String path) {
    return "/api/plugin/$path";
  }

  static Future<PluginSettings?> getSettings() async {
    return await _API.get<PluginSettings>(_path("settings"), adapter: ApiAdapter.pluginSettings);
  }

  static Future<bool> setSettings(PluginSettings pluginSettings) async {
    return await _API.postNoReturn(_path("settings"), pluginSettings.serialize());
  }

  static Future<bool> setCertificate(PluginCertificate certificate) async {
    return await _API.postNoReturn(_path("certificate/upload"), certificate.serialize());
  }

  static Future<bool> generateCertificate(String hostname) async {
    return await _API.postNoReturn(_path("certificate/generate"), hostname);
  }
}

class ProvisioningApi {

  static String _path(String path) {
    return "/api/provisioning/$path";
  }

  static Future<DownloadFile?> add(String name, String publicURL) async {
    return await _API.getFile(_path("add"), queryParameters: {"name": name, "publicURL": publicURL});
  }

  static Future<List<ProvisioningClient>?> list() async {
    return await _API.getList<ProvisioningClient>(_path("list"), adapter: ApiAdapter.provisioningClient);
  }

  static Future<bool> delete(String name) async {
    return await _API.postNoReturn(_path("delete"), name);
  }
}

class LogApi {
  static String _path(String path) {
    return "/api/log/$path";
  }

  static Future<List<LogEntry>?> getLog(Pagination pagination) async {
    String? lines= await _API.get<String>(_path("log"), queryParameters: pagination.serialize());
    if (lines == null) {
      return null;
    }
    return lines.split("\n").map((e) => LogEntry(e)).toList();
  }

  static Future<int?> getLogCount() async {
    return await _API.get<int>(_path("count"));
  }
}

class AccountApi {
  static String _path(String path) {
    return "/api/account/$path";
  }

  static Future<List<String>?> getAll() async {
    return await _API.getList<String>(_path("all"));
  }

  static Future<List<Permission>?> getAllPermissions() async {
    List<String>? permissions = await _API.getList<String>(_path("all-permissions"));
    if (permissions == null) {
      return null;
    }
    return permissions.map((e) => UserPermissions.parsePermission(e)).toList();
  }

  static Future<UserPermissions?> getUserPermissions(String username) async {
    return await _API.get<UserPermissions>(_path("permissions"), queryParameters: {"username": username}, adapter: ApiAdapter.userPermissions);
  }

  static Future<bool> setPermissions(String username, UserPermissions userPermissions) async {
    return await _API.postNoReturn(_path("permissions"), {"username": username, "superAdmin": userPermissions.isSuperAdmin, "systems": userPermissions.serialize()});
  }

  static Future<bool> resetPassword(String username, String password) async {
    return await _API.postNoReturn(_path("reset-password"), {"username": username, "newPassword": base64Encode(utf8.encode(password))});
  }

  static Future<bool> create(String username, String password) async {
    return await _API.postNoReturn(_path("create"), {"username": username, "newPassword": base64Encode(utf8.encode(password))});
  }

  static Future<bool> delete(String username) async {
    return await _API.postNoReturn(_path("delete"), username);
  }

  static Future<bool> superAdmin(String username, bool isSuperAdmin) async {
    return await _API.postNoReturn(_path("superadmin"), {"username": username, "superAdmin": isSuperAdmin});
  }
}


abstract class _EmbeddedApi {
  String system;

  _EmbeddedApi(this.system);

  String _path(String path);

  Future<T?> _get<T>(String path, {T Function(Map<String, dynamic> data)? adapter, Map<String, dynamic>? queryParameters}) async {
    queryParameters ??= <String, dynamic>{};
    queryParameters["system"] = system;
    return await _API.get<T>(path, adapter: adapter, queryParameters: queryParameters);
  }

  Future<List<T>?> _getList<T>(String path, {T Function(Map<String, dynamic> data)? adapter, Map<String, dynamic>? queryParameters}) async {
    queryParameters ??= <String, dynamic>{};
    queryParameters["system"] = system;
    return await _API.getList<T>(path, adapter: adapter, queryParameters: queryParameters);
  }

  Future<DownloadFile?> _getFile(String path, {Map<String, dynamic>? queryParameters}) async {
    queryParameters ??= <String, dynamic>{};
    queryParameters["system"] = system;
    return await _API.getFile(path, queryParameters: queryParameters);
  }

  Future<T?> _post<T>(String path, dynamic data, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    queryParameters ??= <String, dynamic>{};
    queryParameters["system"] = system;
    return await _API.post<T>(path, data, queryParameters: queryParameters, timeout: timeout);
  }

  Future<bool> _postNoReturn(String path, dynamic data, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    queryParameters ??= <String, dynamic>{};
    queryParameters["system"] = system;
    return await _API.postNoReturn(path, data, queryParameters: queryParameters, timeout: timeout);
  }

  Future<int> _postReturnStatus(String path, dynamic data, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    queryParameters ??= <String, dynamic>{};
    queryParameters["system"] = system;
    return await _API.postReturnStatus(path, data, queryParameters: queryParameters, timeout: timeout);
  }

  Future<bool> _postUpload(String path, UploadFile uploadFile, Function(int sent, int total, bool finished) onUploadProgress, dio.CancelToken? cancelToken, {Map<String, dynamic>? queryParameters, Duration timeout = const Duration(seconds: 10)}) async {
    queryParameters ??= <String, dynamic>{};
    queryParameters["system"] = system;
    queryParameters["path"] = uploadFile.path;
    var response = await Session.postFile(_path("upload"), uploadFile, onUploadProgress, cancelToken, queryParameters: queryParameters);
    return HttpUtils.isSuccess(response);
  }
}

class BackupApi extends _EmbeddedApi {
  BackupApi(super.system);

  @override
  String _path(String path) {
     return "/api/backup/$path";
  }

  Future<List<World>?> listWorlds() async {
    return await _getList<World>(_path("worlds/list"), adapter: ApiAdapter.world);
  }

  Future<DownloadFile?> downloadBackup(String path) async {
    return await _getFile(_path("download"), queryParameters: {"path": path});
  }

  Future<List<Backup>?> listBackups() async {
    return await _getList<Backup>(_path("list"), adapter: ApiAdapter.backup);
  }

  Future<bool> createWorldsBackup(List<String> uuids) async {
    return await _postNoReturn(_path("create/world"), uuids);
  }

  Future<bool> deleteBackup(String path) async {
    return await _postNoReturn(_path("delete"), path);
  }

  Future<bool> createFullBackup() async {
    return await _postNoReturn(_path("create/full"), null);
  }
}

class ConsoleApi extends _EmbeddedApi {
  ConsoleApi(super.system);

  @override
  String _path(String path) {
    return "/api/console/$path";
  }

  Future<String?> getLog() async {
    return await _get<String>(_path("log"));
  }

  Future<bool> executeCommand(String command) async {
    return await _postNoReturn(_path("command"), base64Encode(utf8.encode(command)));
  }
}

class PlayerApi extends _EmbeddedApi {
  PlayerApi(super.system);

  @override
  String _path(String path) {
    return "/api/player/$path";
  }

  Future<List<Player>?> getOnlinePlayer(Pagination pagination) async {
    return await _getList<Player>(_path("online"), queryParameters: pagination.serialize(), adapter: ApiAdapter.player);
  }

  Future<int?> getOnlinePlayerCount() async {
    return await _get<int>(_path("count"));
  }
}

class ServerApi extends _EmbeddedApi {
  ServerApi(super.system);

  @override
  String _path(String path) {
    return "/api/server/$path";
  }

  String getServerIconPath() {
    return _path("icon");
  }

  Future<String?> getServerName() async {
    return await _get<String>(_path("name"));
  }

  Future<bool> setServerName(String name) async {
    return await _postNoReturn(_path("name"), name);
  }

  Future<ServerData?> getServerData() async {
    return await _get<ServerData>(_path("data"), adapter: ApiAdapter.serverData);
  }

  Future<bool> stopServer() async {
    return await _postNoReturn(_path("stop"), null);
  }

  Future<bool> reloadServer() async {
    return await _postNoReturn(_path("reload"), null);
  }

  Future<bool> restartServer() async {
    return await _postNoReturn(_path("restart"), null);
  }

  Future<Map<String, String>?> getProperties() async {
    return (await _get<Map<String, dynamic>>(_path("settings")))?.map((key, value) => MapEntry(key, value as String),);
  }

  Future<bool> setProperties(Map<String, String> data) async {
    return await _postNoReturn(_path("settings"), data);
  }
}

class SystemApi extends _EmbeddedApi {
  SystemApi(super.system);

  @override
  String _path(String path) {
    return "/api/system/$path";
  }

  Future<SystemData?> getSystemData() async {
    return await _get<SystemData>(_path("data"), adapter: ApiAdapter.systemData);
  }

  Future<List<SystemData>?> getHistoricSystemData() async {
    return await _getList<SystemData>(_path("historicData"), adapter: ApiAdapter.systemData);
  }
}

class FilesApi extends _EmbeddedApi {
  FilesApi(super.system);

  @override
  String _path(String path) {
    return "/api/files/$path";
  }

  Future<List<ServerFile>?> getFilesList(String path, Pagination pagination) async {
    Map<String, dynamic> queryParameters = pagination.serialize();
    queryParameters["path"] = path;
    return await _getList<ServerFile>(_path("list"), adapter: ApiAdapter.serverFile, queryParameters: queryParameters);
  }

  Future<int?> getFilesCount(String path) async {
    return await _get<int>(_path("count"), queryParameters: {"path": path});
  }

  Future<bool> delete(String path) async {
    return await _postNoReturn(_path("delete"), path);
  }

  Future<bool> createFile(String path) async {
    return await _postNoReturn(_path("create-file"), path);
  }

  Future<bool> createDir(String path) async {
    return await _postNoReturn(_path("create-dir"), path);
  }

  Future<bool> extractFile(String path) async {
    return await _postNoReturn(_path("extract-file"), path, timeout: Duration(days: 1));
  }

  Future<bool> rename(String path, String newPath) async {
    return await _postNoReturn(_path("rename"), {"path": path, "newPath": newPath});
  }

  Future<bool> deleteMultiple(List<String> paths) async {
    return await _postNoReturn(_path("delete-multiple"), paths);
  }

  Future<DownloadFile?> download(String path) async {
    return await _getFile(_path("download"), queryParameters: {"path": path});
  }

  Future<DownloadFile?> downloadMultiple(List<String> paths) async {
    return await _getFile(_path("download-multiple"), queryParameters: {"paths": json.encode(paths)});
  }

  Future<List<String>?> getEditableFiles() async {
    return await _getList<String>(_path("editable-files"));
  }

  Future<bool> setEditableFiles(List<String> fileExtensions) async {
    return await _postNoReturn(_path("editable-files"), fileExtensions);
  }

  Future<bool> upload(UploadFile uploadFile, Function(int sent, int total, bool finished) onUploadProgress, dio.CancelToken? cancelToken) async {
    return _postUpload(_path("upload"), uploadFile, onUploadProgress, cancelToken);
  }
}