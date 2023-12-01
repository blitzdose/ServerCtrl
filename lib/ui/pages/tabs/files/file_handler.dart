import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_highlight/themes/tomorrow-night.dart';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:minecraft_server_remote/utilities/code_controller/code_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../generated/l10n.dart';
import '../../../../navigator_key.dart';
import '../../../../utilities/http/http_utils.dart';
import '../../../../utilities/http/session.dart';
import '../../../../utilities/snackbar/snackbar.dart';
import 'file_entry.dart';
import 'files_controller.dart';

class FileHandler {

  FilesController controller;
  String path;
  FileEntry fileEntry;

  FileHandler(this.controller, this.path, this.fileEntry);

  Future<void> download([List<FileEntry>? fileEntries]) async {
    Map<String, dynamic> jsonData = {};
    jsonData['path'] = path;
    http.Response? response;
    if (fileEntry.type == FileEntry.UP && fileEntries != null) {
      var fileEntryList = [];
      for (FileEntry element in fileEntries) {
        fileEntryList.add({'name': element.name});
      }
      jsonData['names'] = fileEntryList;
      response = await Session.post("/api/files/download-multiple", jsonEncode(jsonData));
    } else if (fileEntry.type == FileEntry.FILE) {
      jsonData['name'] = fileEntry.name;
      response = await Session.post("/api/files/download", jsonEncode(jsonData));
    } else {
      jsonData['names'] = [{'name': fileEntry.name}];
      response = await Session.post("/api/files/download-multiple", jsonEncode(jsonData));
    }
    if (HttpUtils.isSuccess(response)) {
      var jsonResponse = jsonDecode(response.body);
      String id = jsonResponse['id'];
      if (fileEntry.type == FileEntry.DIRECTORY || fileEntries != null) {
        fileEntry.name = "$id.zip";
      }

      StreamSubscription? listener;
      List<int> bytes = [];
      var receivedLength = 0.obs;
      var fileSaved = false.obs;
      String? filePath;
      var status = S.current.downloading.obs;

      var (stream, totalLength) = await Session.getFile("/api/files/download?id=$id");

      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Obx(() => WillPopScope(
            onWillPop: () async {
              return fileSaved.value;
            },
            child: AlertDialog(
              title: Text(status.value),
              content: Obx(() => !fileSaved.value ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    value: receivedLength.value != totalLength ? (receivedLength.value / totalLength) : null,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4.0)),
                  Text(totalLength != 0 ? "${(receivedLength.value / totalLength * 100).round()}%" : "100%", textAlign: TextAlign.end)
                ],
              ) : Text(S.current.downloadedFilenameSuccessfully(fileEntry.name)),
              ),
              actions: !fileSaved.value ? <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(S.current.cancel)),
              ] : <Widget>[
                TextButton(
                    onPressed: () async {
                      await Share.shareXFiles([XFile(filePath!, name: filePath!.split("/").last)]);
                    },
                    child: Text(S.current.share)),
                TextButton(
                    onPressed: () async {
                      status(S.current.saving);
                      fileSaved(false);
                      var params = SaveFileDialogParams(sourceFilePath: filePath);
                      String? savedFilePath = await FlutterFileDialog.saveFile(params: params);
                      if (savedFilePath != null) {
                        Snackbar.createWithTitle(S.current.fileAndName(fileEntry.name), S.current.savedSuccessfully, false, 5);
                      } else {
                        Snackbar.createWithTitle(S.current.fileAndName(fileEntry.name), S.current.errorWhileSavingFile, true);
                      }
                      fileSaved(true);
                    },
                    child: Text(S.current.saveFile)),
                TextButton(
                    onPressed: () {
                      if (listener != null) {
                        listener.cancel();
                      }
                      Navigator.pop(context, true);
                    },
                    child: Text(S.current.close)),
              ],
            ),
          ));
        },
      );

      listener = stream.listen((value) {
        bytes.addAll(value);
        receivedLength(receivedLength.value + value.length);
      });
      listener.onDone(() async {
        receivedLength(totalLength);
        final Directory cacheDir = await getApplicationCacheDirectory();
        File file = File("${cacheDir.path}/${fileEntry.name}");
        File savedFile = await file.writeAsBytes(bytes, flush: true);
        filePath = savedFile.path;
        fileSaved(true);
        status(S.current.downloaded);
      });
      listener.onError((object) {
        Navigator.pop(navigatorKey.currentContext!, true);
        Snackbar.createWithTitle(S.current.fileAndName(fileEntry.name), S.current.errorWhileDownloadingFile, true);
      });

    } else {
      Snackbar.createWithTitle(S.current.fileAndName(fileEntry.name), S.current.errorWhileDownloadingFile, true);
    }
  }

  void rename() async {
    String type = S.current.file;
    if (fileEntry.type == FileEntry.DIRECTORY) {
      type = S.current.directory;
    }
    var newName = fileEntry.name.obs;
    var newNameController = TextEditingController(text: newName.value);

    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Padding(
            padding: const EdgeInsets.all(32),
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              title: Text(S.current.rename),
              content: SizedBox(
                width: min(500, MediaQuery.of(context).size.width),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: S.current.name
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          controller: newNameController,
                          onChanged: (value) {
                            newName(value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.cancel)),
                Obx(() =>
                    TextButton(onPressed: newName.isNotEmpty ? () {
                      _rename(fileEntry, newNameController.text, type);
                      Navigator.pop(context, true);
                      } : null, child: Text(S.current.rename))
                ),
              ],
            )
        );
      },
    );
  }

  void _rename(FileEntry fileEntry, String newName, String type) async {
    controller.showProgress(true);
    Map<String, dynamic> jsonData = {};
    jsonData['path'] = path;
    jsonData['name'] = fileEntry.name;
    jsonData['newName'] = newName;
    var response = await Session.post("/api/files/rename", jsonEncode(jsonData));
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle("${type.capitalizeFirst} \"${fileEntry.name}\"", S.current.successfullyRenamed);
    } else {
      Snackbar.createWithTitle("${type.capitalizeFirst} \"${fileEntry.name}\"", S.current.errorRenamingType, true);
    }
    controller.updateData(true);
  }

  void delete() async {
    String type = S.current.file;
    if (fileEntry.type == FileEntry.DIRECTORY) {
      type = S.current.directory;
    }
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.deleteFile),
          content: Text(S.current.deleteFileMessage(fileEntry.name)),
          actions: <Widget>[
            TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.no)),
            TextButton(onPressed: () {
              _delete(fileEntry, type);
              Navigator.pop(context, true);
            }, child: Text(S.current.delete)),
          ],
        );
      },
    );
  }

  void _delete(FileEntry fileEntry, String type) async {
    controller.showProgress(true);
    Map<String, dynamic> jsonData = {};
    jsonData['path'] = path;
    jsonData['name'] = fileEntry.name;
    jsonData['dir'] = fileEntry.type == FileEntry.DIRECTORY;
    var response = await Session.post("/api/files/delete", jsonEncode(jsonData));
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle("${type.capitalizeFirst} ${fileEntry.name}", S.current.successfullyDeleted);
    } else {
      Snackbar.createWithTitle("${type.capitalizeFirst} ${fileEntry.name}", S.current.errorDeletingFile, true);
    }
    controller.updateData(true);
  }

  void edit() async {
    controller.showProgress(true);
    Map<String, dynamic> jsonData = {};
    jsonData['path'] = path;
    jsonData['name'] = fileEntry.name;

    bool fileChanged = false;
    var response = await Session.post("/api/files/download", jsonEncode(jsonData));
    if (HttpUtils.isSuccess(response)) {
      var jsonResponse = jsonDecode(response.body);
      String id = jsonResponse['id'];

      StreamSubscription? listener;
      List<int> bytes = [];
      var receivedLength = 0.obs;

      var (stream, totalLength) = await Session.getFile("/api/files/download?id=$id");

      listener = stream.listen((value) {
        bytes.addAll(value);
        receivedLength(receivedLength.value + value.length);
      });
      listener.onError((object) {
        Navigator.pop(navigatorKey.currentContext!, true);
        Snackbar.createWithTitle(S.current.fileAndName(fileEntry.name), S.current.errorWhileDownloadingFile, true);
        controller.showProgress(false);
      });
      listener.onDone(() async {
        receivedLength(totalLength);
        var codeController = MyCodeController(
          text: utf8.decode(bytes),
          languageName: fileEntry.name.split(".").last,
        );
        
        var codeEditor = CodeTheme(
            data: const CodeThemeData(styles: tomorrowNightTheme),
            child: CodeField(
              controller: codeController,
              expands: true,
              textStyle: const TextStyle(fontFamily: 'SourceCode'),
              onChanged: (p0) {
                fileChanged = true;
              },
            )
        );

        controller.showProgress(false);

        await showDialog(
            barrierDismissible: false,
            context: navigatorKey.currentContext!,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async {
                  if (!fileChanged) {
                    return true;
                  }
                  bool shouldPop = false;
                  await showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(S.current.discardChanges),
                        content: Text(S.current.allYourChangesWillBeLost),
                        actions: <Widget>[
                          TextButton(onPressed: () {
                            Navigator.pop(context, true);
                          }, child: Text(S.current.no)),
                          TextButton(onPressed: () {
                            shouldPop = true;
                            Navigator.pop(context, true);
                          }, child: Text(S.current.discard)),
                        ],
                      );
                    },
                  );

                  return shouldPop;
                },
                child: Dialog.fullscreen(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(fileEntry.name),
                      leading: IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () async {
                          if (!fileChanged) {
                            Navigator.pop(context, true);
                            return;
                          }
                          await showDialog(
                            context: navigatorKey.currentContext!,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(S.current.discardChanges),
                                content: Text(S.current.allYourChangesWillBeLost),
                                actions: <Widget>[
                                  TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.no)),
                                  TextButton(onPressed: () {
                                    Navigator.pop(context, true);
                                    Navigator.pop(context, true);
                                  }, child: Text(S.current.discard)),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.save_rounded),
                          onPressed: () async {
                            String editedText = codeController.text;
                            final Directory cacheDir = await getApplicationCacheDirectory();
                            File file = File("${cacheDir.path}/${fileEntry.name}");
                            File savedFile = await file.writeAsBytes(utf8.encode(editedText), flush: true);
                            String filePath = savedFile.path;

                            Map<String, String> files = {};
                            files[fileEntry.name] = filePath;

                            showDialog(
                              context: navigatorKey.currentContext!,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(S.current.saving),
                                  content: const LinearProgressIndicator(value: null),
                                  actions: <Widget>[
                                    TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.cancel)),
                                  ],
                                );
                              },
                            );

                            var response = await Session.postFile("/api/files/upload", path, files, (byteCount, totalLength, isFinished, sink) {});
                            Navigator.pop(navigatorKey.currentContext!, true);
                            if (HttpUtils.isSuccess(response)) {
                              fileChanged = false;
                              Snackbar.createWithTitle(S.current.files, S.current.fileSavedSuccessfully);
                            } else {
                              Snackbar.createWithTitle(S.current.files, S.current.errorWhileSavingFile, true);
                            }
                          },
                        )
                      ],
                    ),
                    body: codeEditor,
                  ),
                ),
              );
            }
        );
      });
    } else {
      Snackbar.createWithTitle(S.current.fileAndName(fileEntry.name), S.current.errorWhileDownloadingFile, true);
      controller.showProgress(false);
    }
  }
}