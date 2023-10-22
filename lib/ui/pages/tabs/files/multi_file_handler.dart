import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/files/file_handler.dart';

import '../../../../generated/l10n.dart';
import '../../../../navigator_key.dart';
import '../../../../utilities/http/http_utils.dart';
import '../../../../utilities/http/session.dart';
import '../../../../utilities/snackbar/snackbar.dart';
import 'file_entry.dart';
import 'files_controller.dart';

class MultiFileHandler{
  FilesController controller;
  String path;
  List<FileEntry> fileEntries;

  MultiFileHandler(this.controller, this.path, this.fileEntries);

  Future<void> download() async {
    controller.showProgress(true);
    FileHandler fileHandler = FileHandler(controller, path, FileEntry("", 0, FileEntry.UP, DateTime.now()));
    await fileHandler.download(fileEntries);
    controller.showProgress(false);
  }

  Future<void> delete() async {
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.deleteFiles),
          content: Text(S.current.theSelectedFilesWillBePermanentlyDeleted),
          actions: <Widget>[
            TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.no)),
            TextButton(onPressed: () async {
              await _delete();
              Navigator.pop(navigatorKey.currentContext!, true);
            }, child: Text(S.current.delete)),
          ],
        );
      },
    );
  }

  Future<void> _delete() async {
    controller.showProgress(true);
    Map<String, dynamic> jsonData = {};
    jsonData['path'] = path;
    jsonData['names'] = <Map<String, dynamic>>[];
    jsonData['names'].addAll(fileEntries.map((e) => {'name': e.name}));
    var response = await Session.post("/api/files/delete-multiple", jsonEncode(jsonData));
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle("Files", S.current.successfullyDeleted);
    } else {
      Snackbar.createWithTitle("Files", S.current.errorDeletingFiles, true);
    }
  }
}