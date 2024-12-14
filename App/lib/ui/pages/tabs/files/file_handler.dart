import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:server_ctrl/utilities/code_controller/code_field.dart';
import 'package:server_ctrl/utilities/http/download/downloader.dart';

import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_highlight/themes/tomorrow-night.dart';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:server_ctrl/utilities/code_controller/code_controller.dart';
import 'package:path_provider/path_provider.dart';

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

      DownloaderDialog downloaderDialog = DownloaderDialog((progress) {}, (success) {
        if (!success) {
          Navigator.pop(navigatorKey.currentContext!, true);
          Snackbar.createWithTitle(S.current.fileAndName(fileEntry.name), S.current.errorWhileDownloadingFile, true);
        }
      });
      downloaderDialog.startDownload("${Session.baseURL}/api/files/download?id=$id", fileEntry.name, Session.headers);
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

      var (client, stream, totalLength) = await Session.getFile("/api/files/download?id=$id");

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
        client.close();
        receivedLength(totalLength);
        var code = utf8.decode(bytes);
        var linesOfCode = code.split("\n").length;
        if (linesOfCode > 5000) {
          controller.showProgress(false);
          showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(S.current.fileTooLarge),
                  content: Text(S.current.fileTooLargeText),
                  actions: [
                   TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.ok))
                  ]
              );
            },
          );
          return;
        }
        var codeController = MyCodeController(
          text: code.replaceAll("\r\n", "\n"),
          languageName: fileEntry.name.split(".").last
        ).obs;

        LinkedScrollControllerGroup codeScrollController = LinkedScrollControllerGroup();
        
        Widget codeField = Obx(() =>MyCodeField(
            controller: codeController.value,
            expands: true,
            textStyle: const TextStyle(fontFamily: 'SourceCode'),
            lineNumberStyle: LineNumberStyle(width: 14.0 * linesOfCode.toString().length),
            onChanged: (p0) {
              fileChanged = true;
            },
            codeScroll: codeScrollController,
        ));

        var codeEditor = CodeTheme(
            data: const CodeThemeData(styles: tomorrowNightTheme),
            child: codeField
        );

        controller.showProgress(false);

        var appBarTitle = (Text(fileEntry.name) as Widget).obs;
        var searchIcon = const Icon(Icons.search_rounded).obs;
        TextEditingController searchController = TextEditingController();
        var caseSensitive = false.obs;
        var regexSearch = false.obs;

        searchController.addListener(() {
          updateCodeController(codeController, code, searchController, caseSensitive, regexSearch, codeScrollController);
        });

        showDialog(
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
                      title: Obx(() => appBarTitle.value),
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
                          icon: Obx(() => searchIcon.value),
                          onPressed: () {
                            if (searchIcon.value.icon == Icons.search_rounded) {
                              searchIcon(const Icon(Icons.search_off_rounded));
                              appBarTitle(TextField(
                                controller: searchController,
                                maxLines: 1,
                                autofocus: true,
                                style: const TextStyle(fontSize: 21),
                                decoration: InputDecoration(
                                    hintText: "Search ...",
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                        icon: const Icon(Icons.tune_rounded),
                                        onPressed: () {
                                          showDialog(
                                          context: navigatorKey.currentContext!,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(S.current.settings),
                                              content: SizedBox(
                                                width: min(300, MediaQuery.of(context).size.width),
                                                child: Obx(() => ListView(
                                                  shrinkWrap: true,
                                                    children: [
                                                      CheckboxListTile(
                                                          value: caseSensitive.value,
                                                          title: Text(S.current.casesensitive),
                                                          onChanged: (value) {
                                                            caseSensitive(value);
                                                            updateCodeController(codeController, code, searchController, caseSensitive, regexSearch, codeScrollController);
                                                      }),
                                                      CheckboxListTile(
                                                          value: regexSearch.value,
                                                          title: Text(S.current.regex),
                                                          onChanged: (value) {
                                                            regexSearch(value);
                                                            updateCodeController(codeController, code, searchController, caseSensitive, regexSearch, codeScrollController);
                                                          })
                                                    ],
                                                  ),
                                              )),
                                              actions: <Widget>[
                                                TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.ok)),
                                              ],
                                            );
                                          });
                                    })
                                ),
                              ) as Widget);
                            } else {
                              searchController.clear();
                              searchIcon(const Icon(Icons.search_rounded));
                              appBarTitle(Text(fileEntry.name) as Widget);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.save_rounded),
                          onPressed: () async {
                            if (kIsWeb) {
                              await saveInWeb(codeController.value, fileChanged);
                              return;
                            }
                            String editedText = codeController.value.text;
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

  void updateCodeController(Rx<MyCodeController> codeController, String code, TextEditingController searchController, RxBool caseSensitive, RxBool regexSearch, codeScrollController) {
    codeController(MyCodeController(
        text: codeController.value.text,
        languageName: fileEntry.name.split(".").last,
        stringMap: {
          searchController.value.text: const TextStyle(backgroundColor: Colors.amber, color: Colors.black)
        },
        caseSensitiveStringMap: caseSensitive.value,
        regexSearch: regexSearch.value
    ));

    if (codeController.value.styleRegExp != null && searchController.text.isNotEmpty) {
      int? index = codeController.value.styleRegExp!.firstMatch(codeController.value.text)?.start;
      if (index != null) {
        String codeSubstring = codeController.value.text.substring(0, index);
        int lines = "\n".allMatches(codeSubstring).length;
        codeScrollController.animateTo(24.0*lines, duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    }
  }

  void extract() async {
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.extractFile),
          content: Text(S.current.extractFileMessage(fileEntry.name)),
          actions: <Widget>[
            TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.no)),
            TextButton(onPressed: () {
              _extract(fileEntry);
              Navigator.pop(context, true);
            }, child: Text(S.current.extract)),
          ],
        );
      },
    );
  }

  void _extract(FileEntry fileEntry) async {
    controller.showProgress(true);
    Map<String, dynamic> jsonData = {};
    jsonData['path'] = path;
    jsonData['name'] = fileEntry.name;
    var response = await Session.post("/api/files/extract-file", jsonEncode(jsonData));
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(fileEntry.name, S.current.successfullyExtracted);
    } else {
      Snackbar.createWithTitle(fileEntry.name, S.current.errorExtractingFile, true);
    }
    controller.updateData(true);
  }

  Future<void> saveInWeb(CodeController codeController, bool fileChanged) async {
    String editedText = codeController.text;
    Uint8List bytes = utf8.encode(editedText);

    Map<String, Uint8List> files = {};
    files[fileEntry.name] = bytes;

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

    var response = await Session.postFileFromWeb("/api/files/upload", path, files, CancelToken(), (byteCount, totalLength, isFinished) {});
    Navigator.pop(navigatorKey.currentContext!, true);
    if (HttpUtils.isSuccess(response)) {
      fileChanged = false;
      Snackbar.createWithTitle(S.current.files, S.current.fileSavedSuccessfully);
    } else {
      Snackbar.createWithTitle(S.current.files, S.current.errorWhileSavingFile, true);
    }
  }
}