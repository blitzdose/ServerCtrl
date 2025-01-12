import 'dart:async';
import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:server_ctrl/ui/pages/tabs/files/add_file_handler.dart';
import 'package:server_ctrl/ui/pages/tabs/files/file_handler.dart';
import 'package:server_ctrl/ui/pages/tabs/files/multi_file_handler.dart';
import 'package:server_ctrl/ui/pages/tabs/tab.dart';
import 'package:server_ctrl/utilities/http/session.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';

import '../../../../generated/l10n.dart';
import '../../../../utilities/http/http_utils.dart';
import '../../../navigation/layout_structure.dart';
import 'file_entry.dart';

enum PopupMenuItems {edit, extract, download, rename, delete}

class FilesController extends TabxController {

  final fileEntries = <Widget>[].obs;
  int position = 0;
  final fileScrollController = ScrollController().obs;

  List<String> editableFiles = [];
  List<String> extractableFiles = ["zip", "tar", "gz"];

  bool canUpdate = true;

  List<String> path = [];

  BuildContext? context;

  var multiSelectState = false.obs;
  final allShownFileEntries = <FileEntry, RxBool>{}.obs;

  VoidCallback? fileScrollControllerListener;

  FilesController();

  void disableMultiSelectMode() {
    canUpdate = true;
    multiSelectState(false);
    allShownFileEntries.clear();
    setAction();
    setLeading();
    setFab();
    showProgress(true);
    updateData(true);
  }

  @override
  Future<http.Response> fetchData() {
    return Session.post("/api/files/list", "{\"path\": \"/${path.join("/")}\", \"limit\": 50, \"position\": $position}");
  }
  
  Future<http.Response> fetchEditableFiles() {
    return Session.get("/api/files/editable-files");
  }

  @override
  void updateData([bool reset = false]) async {
    if (!canUpdate) {
      return;
    }
    canUpdate = false;
    showProgress(true);
    multiSelectState(false);

    if (reset) {
      position = 0;
    }

    http.Response? response;
    try {
      response = await fetchData();
    } on Exception catch(_) {
      showProgress(false);
      canUpdate = true;
      return;
    }
    List<FileEntry> fileEntriesResponse = [];
    if (HttpUtils.isSuccess(response)) {
      fileEntriesResponse.addAll(FileEntry.parseEntries(response.body));
      response = await fetchEditableFiles();
      if (HttpUtils.isSuccess(response)) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> fileExtensions = jsonResponse['fileExtensions'];
        editableFiles = fileExtensions.map((e) => e.toString()).toList();
      }
      showProgress(false);
    }
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      canUpdate = true;
      timer.cancel();
    });

    if (reset) {
      fileEntries.clear();
      allShownFileEntries.clear();
      if (path.isNotEmpty) {
        fileEntries.add(createListItem(FileEntry("..", 0, 2, DateTime.now())));
      }
    }
    for (FileEntry fileEntry in fileEntriesResponse) {
      fileEntries.add(createListItem(fileEntry));
    }
    position = fileEntries.length;
    if (fileEntries.isNotEmpty && path.isNotEmpty) {
      position = fileEntries.length + -1;
    }
  }

  Widget createListItem(FileEntry fileEntry) {
    IconData icon = Icons.folder_rounded;
    if (fileEntry.type == FileEntry.FILE) {
      icon = Icons.description_rounded;
    } else if (fileEntry.type == FileEntry.UP) {
      icon = Icons.arrow_upward_rounded;
    }
    GlobalKey keyEntry = GlobalKey();
    GlobalKey keyMenu = GlobalKey();

    var checked = false.obs;
    if (fileEntry.type != FileEntry.UP) {
      allShownFileEntries[fileEntry] = checked;
    }
    return SizedBox(
      height: 58,
      child: InkWell(
        key: keyEntry,
        onTap: () {
          if (multiSelectState.value) {
            if (fileEntry.type != FileEntry.UP) {
              checked(checked.isFalse);
            }
            return;
          }
          RenderBox box = keyEntry.currentContext?.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);
          double y = position.dy + 5;
          double x = MediaQuery.of(keyEntry.currentContext!).size.width;
          handleItemClick(fileEntry, x, y);
        },
        onLongPress: () {
          multiSelectState(true);
          canUpdate = false;
          checked(true);
          setAction();
          setLeading();
          LayoutStructureState.controller.fab(Container());
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              const Padding(padding: EdgeInsets.only(right: 16)),
              Expanded(
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(fileEntry.name, style: const TextStyle(fontSize: 16),),
                        if (fileEntry.type != FileEntry.UP) Opacity(
                          opacity: 0.75,
                          child: Text(
                            "${DateFormat('dd. MMM. yyyy').format(fileEntry.timestamp)}\t\t\t${fileEntry.parseSize()}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    !multiSelectState.value || fileEntry.type == FileEntry.UP ? fileEntry.type == FileEntry.DIRECTORY ? IconButton(
                        key: keyMenu,
                        onPressed: () {
                          RenderBox box = keyEntry.currentContext?.findRenderObject() as RenderBox;
                          Offset position = box.localToGlobal(Offset.zero);
                          double y = position.dy + 5;
                          double x = MediaQuery.of(keyEntry.currentContext!).size.width;
                          showPopupMenu(fileEntry, x, y);
                    }, icon: const Icon(Icons.more_vert_rounded)) : Container() :
                    Checkbox(
                        value: checked.value,
                        onChanged: (value) {
                          checked(value);
                        }
                    )
                  ],
                ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  handleItemClick(FileEntry fileEntry, double x, double y) {
    if (fileEntry.type == FileEntry.DIRECTORY) {
      if (canUpdate) {
        path.add(fileEntry.name);
        updateData(true);
        setFab();
      }

    } else if (fileEntry.type == FileEntry.UP) {
      if (canUpdate) {
        path.removeLast();
        updateData(true);
        setFab();
      }
    } else if (fileEntry.type == FileEntry.FILE) {
      showPopupMenu(fileEntry, x, y);
    }
  }

  void showPopupMenu(FileEntry fileEntry, dx, dy) async {
    if (context == null) {
      return;
    }
    FileHandler fileHandler = FileHandler(this, "/${path.join("/")}", fileEntry);
    PopupMenuItems? value = await showMenu(
        context: context!,
        position: RelativeRect.fromLTRB(dx, dy, 0, 0),
        items: [
          if (fileEntry.type == FileEntry.FILE && editableFiles.contains(fileEntry.name.split(".").last)) 
            PopupMenuItem<PopupMenuItems>(
                value: PopupMenuItems.edit, 
                child: Text(S.current.edit)
            ),
          if (fileEntry.type == FileEntry.FILE && extractableFiles.contains(fileEntry.name.split(".").last))
            PopupMenuItem<PopupMenuItems>(
                value: PopupMenuItems.extract,
                child: Text(S.current.extract)
            ),
          PopupMenuItem<PopupMenuItems>(
            value: PopupMenuItems.download,
            child: Text(S.current.download)
          ),
          PopupMenuItem<PopupMenuItems>(
            value: PopupMenuItems.rename,
            child: Text(S.current.rename)
          ),
          PopupMenuItem<PopupMenuItems>(
            value: PopupMenuItems.delete,
            child: Text(S.current.delete)
          )
        ],
      elevation: 8
    );

    switch (value) {
      case PopupMenuItems.download:
        fileHandler.download();
      case PopupMenuItems.rename:
        fileHandler.rename();
      case PopupMenuItems.delete:
        fileHandler.delete();
        break;
      case PopupMenuItems.edit:
        fileHandler.edit();
        break;
      case PopupMenuItems.extract:
        fileHandler.extract();
      default:
        break;
    }
  }

  @override
  void setAction() {
    LayoutStructureState.controller.actions.clear();
    if (multiSelectState.value) {
      LayoutStructureState.controller.actions.add(IconButton(
          onPressed: () async {
            List<FileEntry> files = getSelectedFiles();
            if (files.isEmpty) {
              Snackbar.createWithTitle(S.current.files, S.current.nothingSelected, true);
              return;
            }
            MultiFileHandler multiFileHandler = MultiFileHandler(this, "/${path.join("/")}", files);
            await multiFileHandler.download();
            disableMultiSelectMode();
          },
          icon: const Icon(Icons.download_rounded)
      ));
      LayoutStructureState.controller.actions.add(IconButton(
          onPressed: () async {
            List<FileEntry> files = getSelectedFiles();
            if (files.isEmpty) {
              Snackbar.createWithTitle(S.current.files, S.current.nothingSelected, true);
              return;
            }
            MultiFileHandler multiFileHandler = MultiFileHandler(this, "/${path.join("/")}", files);
            await multiFileHandler.delete();
            disableMultiSelectMode();
          },
          icon: const Icon(Icons.delete_rounded)));
      LayoutStructureState.controller.actions.add(IconButton(
          onPressed: () {
            bool containsUnselectedElements = allShownFileEntries.values.contains(false.obs);
            for (var element in allShownFileEntries.values) {
              element(containsUnselectedElements);
            }
          },
          icon: const Icon(Icons.select_all_rounded)));
    } else {
      LayoutStructureState.controller.actions.add(IconButton(
          onPressed: () {
            updateData(true);
          },
          icon: const Icon(Icons.refresh_rounded)
      ));
    }
  }

  List<FileEntry> getSelectedFiles() {
    Map<FileEntry, RxBool> selectedFiles = {};
    selectedFiles.addAll(allShownFileEntries);
    selectedFiles.removeWhere((key, value) => value.isFalse);
    return selectedFiles.keys.toList();
  }

  @override
  void setLeading() {
    if (multiSelectState.value) {
      LayoutStructureState.controller.leading(IconButton(
          onPressed: () {
            disableMultiSelectMode();
          },
          icon: const Icon(Icons.close_rounded)
      ));
    } else {
      LayoutStructureState.controller.leading.value = null;
    }
  }


  @override
  void setFab() {
    LayoutStructureState.controller.fab(
      SpeedDial(
        icon: Icons.add_rounded,
        activeIcon: Icons.close_rounded,
        spacing: 16,
        renderOverlay: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        childMargin: EdgeInsets.zero,
        childPadding: const EdgeInsets.all(8.0),
        elevation: 6,
        backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
        foregroundColor: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.create_new_folder_rounded),
            label: S.current.createFolder,
            onTap: () => AddFileHandler.createFolderOrFile(this, "/${path.join("/")}", true),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            foregroundColor: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
            backgroundColor: Theme.of(Get.context!).colorScheme.secondaryContainer
          ),
          SpeedDialChild(
              child: const Icon(Icons.note_add_rounded),
              label: S.current.createFile,
              onTap: () => AddFileHandler.createFolderOrFile(this, "/${path.join("/")}", false),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              foregroundColor: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(Get.context!).colorScheme.secondaryContainer
          ),
          SpeedDialChild(
              child: const Icon(Icons.upload_file_rounded),
              label: S.current.uploadFiles,
              onTap: () => AddFileHandler.uploadFile(this, "/${path.join("/")}"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              foregroundColor: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(Get.context!).colorScheme.secondaryContainer
          )
        ],
      )
    );
  }

  @override
  void continueTimer() {
    updateData(true);
    BackButtonInterceptor.remove(myInterceptor);
    BackButtonInterceptor.add(myInterceptor);
    if (fileScrollController.value.hasClients) {
      fileScrollControllerListener = () {
        if (fileScrollController.value.position.userScrollDirection == ScrollDirection.reverse) {
          LayoutStructureState.controller.fab(Container());
        } else if (!multiSelectState.value) {
          setFab();
        }
        if (fileScrollController.value.position.extentAfter < 10) {
          if (canUpdate) {
            updateData();
          }
        }
      };
      fileScrollController.value.addListener(fileScrollControllerListener!);
    }
  }
  @override
  void cancelTimer() {
    canUpdate = true;
    multiSelectState(false);
    allShownFileEntries.clear();
    fileEntries.clear();
    //LayoutStructureState.controller.fab(Container());
    BackButtonInterceptor.remove(myInterceptor);
    if (fileScrollControllerListener != null) {
      fileScrollController.value.removeListener(fileScrollControllerListener!);
    }
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (multiSelectState.value) {
      disableMultiSelectMode();
      return true;
    }
    if (path.isNotEmpty) {
      path.removeLast();
      updateData(true);
      return true;
    } else {
      return false;
    }
  }
}