import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/generated/l10n.dart';
import 'package:server_ctrl/navigator_key.dart';
import 'package:server_ctrl/ui/navigation/layout_structure.dart';
import 'package:server_ctrl/ui/pages/tabs/backups/models/backup_state.dart';
import 'package:server_ctrl/ui/pages/tabs/home/home.dart';
import 'package:server_ctrl/ui/pages/tabs/tab.dart';
import 'package:server_ctrl/utilities/dialogs/dialogs.dart';
import 'package:server_ctrl/utilities/http/download/downloader.dart';
import 'package:server_ctrl/utilities/http/http_utils.dart';
import 'package:server_ctrl/utilities/http/session.dart';
import 'package:http/http.dart' as http;
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';
import 'package:server_ctrl/values/colors.dart';

class BackupsController extends TabxController {
  final RxMap<String, Widget> backupItems = <String, Widget>{}.obs;
  bool initDone = false;

  BackupsController() {
    updateData();
    initDone = false;
  }

  @override
  Future<http.Response> fetchData() {
    return Session.get("/api/backup/list");
  }

  @override
  void updateData() async {
    var response = await fetchData();
    if (!HttpUtils.isSuccess(response)) {
      return;
    }
    setBackups(jsonDecode(response.body));
    if (!initDone) {
      showProgress(false);
      initDone = true;
    }
  }

  void setBackups(var data) {
    var backups = data["backups"] as Map<String, dynamic>;
    List<String> toBeDeleted = backupItems.keys.toList();
    for (var backup in backups.values) {
      if (backup["fileName"] == null) {
        continue;
      }
      BackupState backupState = BackupState(backup["id"], backup["fileName"], backup["percentageComplete"] * 1.0, BackupStateState.parseState(backup["state"]), backup["date"], backup["timestamp"], backup["size"]);
      backupItems.addAll({"${backupState.timestamp},${backupState.id}": createBackupWidget(backupState)});
      toBeDeleted.remove("${backupState.timestamp},${backupState.id}");
    }
    for (var id in toBeDeleted) {
      backupItems.remove(id);
    }

    backupItems(Map.fromEntries(
      backupItems.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key) * -1)
    ));
  }

  Widget createBackupWidget(BackupState backupState) {
    return Card(
      surfaceTintColor: MColors.cardTint(navigatorKey.currentContext!),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (backupState.state == BackupStateState.RUNNING) {
            Snackbar.createWithTitle(S.current.backup, S.current.backup_is_running);
            return;
          }
          showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: true,
            builder: (context) {
              return Padding(
                  padding: const EdgeInsets.all(32),
                  child: AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      title: Text(S.current.backup),
                      content: SizedBox(
                        width: min(500, MediaQuery.of(context).size.width),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(backupState.date, style: const TextStyle(fontSize: 18),),
                            Text(backupState.fileName)
                          ],
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.cancel)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(onPressed: () => deleteBackup(backupState), child: Text(S.current.delete)),
                                TextButton(onPressed: () => downloadBackup(backupState), child: Text(S.current.download))
                              ],
                            )
                          ],
                        )
                      ]
                  )
              );
            },
          );
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                        child: Icon(backupState.state.getIcon(), size: 32),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(backupState.id.toString()),
                            Text(HomeTab.getFileSizeString(bytes: backupState.size, decimals: 2)),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 4.0)),
                        Text(backupState.date, style: const TextStyle(fontSize: 18),),
                        const Padding(padding: EdgeInsets.only(top: 8.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(backupState.state.getLocalizedName()),
                            (backupState.state == BackupStateState.RUNNING) ? Text("${(backupState.percentageComplete * 100).toStringAsFixed(2)}\u{202F}%") : Container(),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: backupState.percentageComplete),
                duration: const Duration(milliseconds: 250),
                builder: (context, value, _) => LinearProgressIndicator(value: value,))
          ],
        ),
      ),
    );
  }

  deleteBackup(BackupState backupState) {
    ConfirmationDialog(
      title: S.current.delete_backup,
      message: S.current.backup_delete_confirmation(backupState.fileName),
      confirmButtonText: S.current.delete,
      onCanceled: (context) => Navigator.pop(context),
      onConfirm: (context) async {
        showProgress(true);
        Navigator.pop(context);
        Navigator.pop(context);
        var response = await Session.post("/api/backup/delete", {"name": backupState.fileName}.toString());
        if (HttpUtils.isSuccess(response)) {
          Snackbar.createWithTitle(S.current.backup, S.current.deleted_backup);
          backupItems.remove("${backupState.timestamp},${backupState.id}");
        } else {
          Snackbar.createWithTitle(S.current.backup, S.current.error_deleting_backup, true);
        }
        showProgress(false);
      }
    ).showConfirmationDialog(navigatorKey.currentContext!);
  }

  downloadBackup(BackupState backupState) async {
    Navigator.pop(navigatorKey.currentContext!);

    DownloaderDialog downloaderDialog = DownloaderDialog((progress) {},  (success) {
      if (!success) {
        Navigator.pop(navigatorKey.currentContext!, true);
        Snackbar.createWithTitle(S.current.fileAndName(backupState.fileName), S.current.errorWhileDownloadingFile, true);
      }
    });
    downloaderDialog.startDownload("${Session.baseURL}/api/backup/download?name=${backupState.fileName}", backupState.fileName, Session.headers);
    return;
  }

  void startFullBackup() async {
    showProgress(true);
    var response = await Session.post("/api/backup/create/full", "");
    if (!HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.backup, S.current.backup_failed, true);
      showProgress(false);
      return;
    }
    showProgress(false);
    updateData();
    Snackbar.createWithTitle(S.current.backup, S.current.backup_started);
  }

  void startWorldsBackup(List<String> worldUUIDs) async {
    showProgress(true);
    Map<String, dynamic> worlds = {"worlds": worldUUIDs};
    var response = await Session.post("/api/backup/create/world", worlds.toString());
    if (!HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.backup, S.current.backup_failed, true);
      showProgress(false);
      return;
    }
    showProgress(false);
    updateData();
    Snackbar.createWithTitle(S.current.backup, S.current.backup_started);
  }

  void selectWorldsBackup() async {
    showProgress(true);
    var response = await Session.get("/api/backup/worlds/list");
    if (!HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.backup, S.current.error_getting_worlds, true);
      showProgress(false);
      return;
    }
    Map<String, dynamic> worlds = jsonDecode(response.body)["worlds"];
    RxMap<String, bool> worldsToBackup = <String, bool>{}.obs;

    showProgress(false);

    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: Text(S.current.create_backup),
            content: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (String world in worlds.keys) ListTile(
                    title: Text(world),
                    leading: Checkbox(
                      value: worldsToBackup[world] ?? false,
                      onChanged: (value) => worldsToBackup[world] = value ?? false,
                    ),
                    onTap: () => worldsToBackup[world] = !(worldsToBackup[world] ?? false),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.cancel)),
              Obx(() => TextButton(onPressed: worldsToBackup.values.contains(true) ? () {
                startWorldsBackup(worldsToBackup.entries.where((element) => element.value,).map((e) => worlds[e.key] as String,).toList());
                Navigator.pop(context);
                } : null, child: Text(S.current.start), ),
              ),
            ],
          );
        },
    );
  }

  @override
  void setFab() {
    LayoutStructureState.controller.fab(
        FloatingActionButton(
          onPressed: () {

            final fullBackup = false.obs;

            showDialog(
                context: navigatorKey.currentContext!, 
                builder: (context) {
                  return AlertDialog(
                    title: Text(S.current.create_backup),
                    content: Obx(() => Column(
                      mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(S.current.select_worlds),
                            leading: Radio<bool>(
                                value: false,
                                groupValue: fullBackup.value,
                                onChanged: (value) => fullBackup(value),
                            ),
                            onTap: () => fullBackup(false),
                          ),
                          ListTile(
                            title: Text(S.current.full_backup),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: fullBackup.value,
                              onChanged: (value) => fullBackup(value),
                            ),
                            onTap: () => fullBackup(true),
                          )
                        ],
                      ),
                    ),
                    actions: [
                      Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.cancel)),
                            TextButton(onPressed: () {
                              if (fullBackup.value) {
                                startFullBackup();
                              } else {
                                selectWorldsBackup();
                              }
                              Navigator.pop(context);
                            }, child: fullBackup.value ? Text(S.current.start) : Text(S.current.next)),
                          ],
                        ),
                      )
                    ],
                  );
                },
            );
            //createAccountDialog();
          },
          child: const Icon(Icons.add_rounded),
        )
    );
  }
}