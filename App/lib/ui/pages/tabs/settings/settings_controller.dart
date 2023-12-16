import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:server_ctrl/ui/pages/tabs/settings/models/server_setting.dart';
import 'package:server_ctrl/ui/pages/tabs/tab.dart';
import 'package:server_ctrl/utilities/http/http_utils.dart';
import 'package:server_ctrl/utilities/http/session.dart';
import 'package:server_ctrl/utilities/permissions/permissions.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';
import '../../../../generated/l10n.dart';
import '../../../navigation/layout_structure.dart';

class SettingsController extends TabxController {

  final doneLoading = false.obs;
  final useHttps = true.obs;
  final port = RxInt(-1);

  final serverSettings = <ServerSetting>[].obs;
  final dataChanged = false.obs;

  SettingsController() {
    dataChanged.listen((p0) {
      setFab();
    });
  }

  @override
  Future<http.Response> fetchData() {
    return Session.get("/api/server/settings");
  }

  Future<http.Response> fetchDataPlugin() {
    return Session.get("/api/plugin/settings");
  }

  @override
  Future<void> updateData() async {
    showProgress(true);
    dataChanged(false);
    if (userPermissions!.hasPermission(Permissions.PERMISSION_PLUGINSETTINGS)) {
      var responsePlugin = await fetchDataPlugin();
      if (HttpUtils.isSuccess(responsePlugin)) {
        parseResponsePlugin(responsePlugin.body);
      }
    }

    if (userPermissions!.hasPermission(Permissions.PERMISSION_SERVERSETTINGS)) {
      var responseServer = await fetchData();
      if (HttpUtils.isSuccess(responseServer)) {
        parseResponseServer(responseServer.body);
      }
    }
    doneLoading(true);
    showProgress(false);
  }

  void parseResponsePlugin(String response) {
    var data = jsonDecode(response);
    useHttps(data["Webserver"]["Https"]);
    port(data["Webserver"]["Port"] as int);
  }

  void parseResponseServer(String response) {
    serverSettings.clear();
    Map<String, dynamic> data = jsonDecode(response)["data"];
    data = Map.fromEntries(data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    for(var entry in data.entries) {
      try {
        bool entryBool = bool.parse(entry.value);
        serverSettings.add(ServerSetting(entry.key, entryBool));
      } on FormatException catch (_) {
        serverSettings.add(ServerSetting(entry.key, entry.value));
      }
    }
  }

  void uploadData() async {
    showProgress(true);
    http.Response? responsePlugin = http.Response("{\"success\": true}", 200);
    http.Response? responseServer = http.Response("{\"success\": true}", 200);
    if (userPermissions!.hasPermission(Permissions.PERMISSION_PLUGINSETTINGS)) {
      var pluginSettingsMap = <String, dynamic>{};
      pluginSettingsMap['https'] = useHttps.value.toString();
      pluginSettingsMap['port'] = port.value.toString();
      responsePlugin = await Session.post("/api/plugin/settings", pluginSettingsMap);
    }
    if (userPermissions!.hasPermission(Permissions.PERMISSION_SERVERSETTINGS)) {
      Map<String, String> serverSettingsMap = <String, String>{};
      for (ServerSetting serverSetting in serverSettings) {
        serverSettingsMap[serverSetting.name] = serverSetting.value.toString();
      }
      String serverSettingsJson = jsonEncode(serverSettingsMap);
      responseServer = await Session.post("/api/server/settings", serverSettingsJson);
    }

    if (!HttpUtils.isSuccess(responsePlugin) || !HttpUtils.isSuccess(responseServer)) {
      Snackbar.createWithTitle(S.current.settings, S.current.errorWhileSavingChanges, true);
    } else {
      Snackbar.createWithTitle(S.current.settings, S.current.savedChanges);
      dataChanged(false);
      setFab();
    }
    showProgress(false);
  }

  void generateCert(String text) async {
    showProgress(true);
    var response = await Session.post("/api/plugin/certificate/generate", "{\"name\": \"$text\"}");
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.settings, S.current.successfullyGeneratedNewCertificate);
    } else {
      Snackbar.createWithTitle(S.current.settings, S.current.errorWhileGeneratingCertificate, true);
    }
    showProgress(false);
  }

  void uploadCert(String certPath, String keyPath) async {
    showProgress(true);
    File certFile = File(certPath);
    File keyFile = File(keyPath);

    Map<String, List<int>> data = <String, List<int>>{};

    data["cert"] = await certFile.readAsBytes();
    data["certKey"] = await keyFile.readAsBytes();


    var response = await Session.postCertFile("/api/plugin/certificate/upload", data);
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.settings, S.current.certificateUploadedSuccessfully);
    } else {
      Snackbar.createWithTitle(S.current.settings, S.current.errorWhileUploadingCertificate, true);
    }
    showProgress(false);
  }

  void uploadCertFromWeb(Uint8List certBytes, Uint8List keyBytes) async {
    showProgress(true);
    Map<String, List<int>> data = <String, List<int>>{};

    data["cert"] = certBytes;
    data["certKey"] = keyBytes;

    var response = await Session.postCertFile("/api/plugin/certificate/upload", data);
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.settings, S.current.certificateUploadedSuccessfully);
    } else {
      Snackbar.createWithTitle(S.current.settings, S.current.errorWhileUploadingCertificate, true);
    }
    showProgress(false);
  }

  @override
  void setAction() {
    LayoutStructureState.controller.actions.clear();
    LayoutStructureState.controller.actions.add(IconButton(
        onPressed: () {
          showProgress(true);
          updateData();
        },
        icon: const Icon(Icons.refresh_rounded)
    ));
  }

  @override
  void setFab() {
    LayoutStructureState.controller.fab(
        dataChanged.isTrue ? FloatingActionButton(
          onPressed: () {
            uploadData();
          },
          child: const Icon(Icons.check_rounded),
        ) : Container()
    );
  }

  @override
  void continueTimer() {
    updateData();
  }
  @override
  void cancelTimer() {}
}