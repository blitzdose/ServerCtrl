import 'dart:convert';
import 'dart:typed_data';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/files/files_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/ui/widgets/code_editor.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/api/models/server_file.dart';
import 'package:server_ctrl/utilities/http/file.dart';
import 'package:server_ctrl/utilities/lazyloader/lazy_loader.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';
import 'package:path/path.dart' as p;

class FilesController extends SubviewController {
  final showProgress = false.obs;

  String path = "/";

  final files = <ServerFile, bool>{}.obs;
  late LazyLoader lazyLoader;

  final multiSelectMode = false.obs;

  List<String> editableFiles = [];
  final List<String> extractableFiles = ["zip", "tar", "gz"];

  FilesController({required super.params});

  @override
  Future<void> updateData() async {

  }

  @override void onShown() {
    super.onShown();
    params.onSetBottom(FilesView.generateBreadcrumb(this, path));
    params.onSetFloatingActionButton(FilesView.generateFloatingActionButton(this));
  }

  @override
  void onInit() {
    super.onInit();

    lazyLoader = LazyLoader<ServerFile>(
      loadingFunction: (pagination) => FilesApi(params.system).getFilesList(path, pagination),
      pageSize: 50,
      onLoadingChanged: (finished) => showProgress(!finished),
      onEntriesUpdated: (entries) => files.assignAll({ for (var file in entries) file: files[file] ?? false})
    );
    lazyLoader.loadNext();

    asyncInit();
  }

  Future<void> asyncInit() async {
    List<String>? editableFiles = await FilesApi(params.system).getEditableFiles();
    if (editableFiles != null) {
      this.editableFiles.assignAll(editableFiles);
    }
  }

  void navigate(String subdir) {
    if (path.endsWith("/")) {
      path += subdir;
    } else {
      path += "/$subdir";
    }
    params.onSetBottom(FilesView.generateBreadcrumb(this, path));
    lazyLoader.refresh();
  }

  void navigateByIndex(String currentPath, int idx) {
    String newPath = "/";
    var pathParts = currentPath.split("/");
    pathParts.removeWhere((element) => element.isEmpty);

    for (int i = 0; i < idx; i++) {
      if (newPath.endsWith("/")) {
        newPath += pathParts[i];
      } else {
        newPath += "/${pathParts[i]}";
      }
    }
    path = newPath;
    params.onSetBottom(FilesView.generateBreadcrumb(this, path));
    lazyLoader.refresh();
  }

  void downloadSingleFile(ServerFile file) async {
    DownloadFile? downloadFile = await FilesApi(params.system).download(file.path);

    if (downloadFile == null) {
      Snackbar.createWithTitle("Error", "Error while trying to download file", true);
      return;
    }

    final progress = Rxn<double>();
    final status = Rxn<TaskStatus>();
    final finished = false.obs;

    Get.dialog(
      FilesView.generateSaveFileDialog(
        file.name,
        progress,
        finished,
        onCancel: () async {
          progress.value = null;
          if (status.value != TaskStatus.complete) {
            await downloadFile.cancel();
          }
          if (await downloadFile.file.exists()) {
            await downloadFile.file.delete();
          }
          Get.back();
        },
        onSave: () async {
          final params = SaveFileDialogParams(
              sourceFilePath: downloadFile.file.path,
              fileName: await downloadFile.name);

          final finalPath = await FlutterFileDialog.saveFile(params: params);

          if (finalPath != null) {
            progress.value = null;
            if (await downloadFile.file.exists()) {
              await downloadFile.file.delete();
            }
            Get.back();
            Snackbar.create("Successfully saved file");
          }
        },
      ),
      barrierDismissible: false,
    );

    downloadFile.progress.listen((data) {
      if (data >= 0) {
        progress(data);
      }
    });

    downloadFile.status.listen((data) {
      status(data);
      if (data == TaskStatus.complete) {
        finished(true);
      }
      if (data == TaskStatus.failed || data == TaskStatus.notFound) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Snackbar.createWithTitle("Error", "Error while trying to download file", true);
      }
    });

    if (await downloadFile.success) {
      downloadFile.status.push(TaskStatus.complete);
    } else {
      if (status.value != TaskStatus.canceled) {
        downloadFile.status.push(TaskStatus.failed);
      }
    }
  }

  void extractSingleFile(ServerFile file) async {
    showProgress(true);
    bool success = await FilesApi(params.system).extractFile(file.path);

    if (success) {
      Snackbar.create("Successfully extracted file");
      lazyLoader.refresh();
    } else {
      Snackbar.createWithTitle("Error", "Error while trying to extract archive", true);
      showProgress(false);
    }
  }

  void editSingleFile(ServerFile file) async {
    if (file.size > 1000000) { //10 MB
      Snackbar.createWithTitle("Error", "Editing files larger than 10 MB is not supported");
      return;
    }
    showProgress(true);
    DownloadFile? downloadFile = await FilesApi(params.system).download(file.path);

    if (downloadFile == null) {
      Snackbar.createWithTitle("Error", "Error while trying to download file", true);
      return;
    }

    final progress = Rxn<double>();
    final status = Rxn<TaskStatus>();

    Get.dialog(
      FilesView.generateEditFileDownloadDialog(
        file.name,
        progress,
        onCancel: () async {
          progress.value = null;
          if (status.value != TaskStatus.complete) {
            await downloadFile.cancel();
          }
          if (await downloadFile.file.exists()) {
            await downloadFile.file.delete();
          }
          Get.back();
        }
      ),
      barrierDismissible: false,
    );

    downloadFile.progress.listen((data) {
      if (data >= 0) {
        progress(data);
      }
    });

    downloadFile.status.listen((data) async {
      status(data);
      if (data == TaskStatus.complete) {
        String code = await downloadFile.file.readAsString();

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        showProgress(false);

        Get.to(() => CodeEditor(
            file: file,
            code: code,
          onExit: () {
            Get.back();
            lazyLoader.refresh();
          },
          onSave: (String newCode) async {
            Uint8List data = utf8.encode(newCode);
            bool success = await FilesApi(params.system).upload(UploadFile(file.path, data, data.lengthInBytes), (sent, total, finished) {

            },);
            if (success) {
              Snackbar.create("Saved successfully");
            } else {
              Snackbar.create("Error while saving", true);
            }
            return success;
          },
        ),
        fullscreenDialog: false);
      }


      if (data == TaskStatus.failed || data == TaskStatus.notFound) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Snackbar.createWithTitle("Error", "Error while trying to download file", true);
      }
    });

    if (await downloadFile.success) {
      downloadFile.status.push(TaskStatus.complete);
    } else {
      if (status.value != TaskStatus.canceled) {
        downloadFile.status.push(TaskStatus.failed);
      }
    }
  }

  void renameFile(ServerFile file, String newName) async {
    showProgress(true);
    bool success = await FilesApi(params.system).rename(file.path, p.join(p.dirname(file.path), newName));

    if (success) {
      Snackbar.create("Successfully renamed file");
      lazyLoader.refresh();
    } else {
      Snackbar.createWithTitle("Error", "Error while trying to rename file", true);
      showProgress(false);
    }

  }

  void deleteSingleFile(ServerFile file) async {
    showProgress(true);
    bool success = await FilesApi(params.system).delete(file.path);

    if (success) {
      Snackbar.create("Successfully deleted file");
      lazyLoader.refresh();
    } else {
      Snackbar.createWithTitle("Error", "Error while trying to delete file", true);
      showProgress(false);
    }
  }

  void deleteMultipleFile(List<ServerFile> files) async {
    showProgress(true);
    bool success = await FilesApi(params.system).deleteMultiple(files.map((e) => e.path).toList());

    if (success) {
      Snackbar.create("Successfully deleted files");
      lazyLoader.refresh();
    } else {
      Snackbar.createWithTitle("Error", "Error while trying to delete files", true);
      showProgress(false);
    }
  }

  void downloadMultipleFile(List<ServerFile> files) async {
    DownloadFile? downloadFile = await FilesApi(params.system).downloadMultiple(
        files.map((file) => file.path).toList());

    if (downloadFile == null) {
      Snackbar.createWithTitle(
          "Error", "Error while trying to download file", true);
      return;
    }

    final progress = Rxn<double>();
    final status = Rxn<TaskStatus>();
    final finished = false.obs;

    Get.dialog(
      FilesView.generateSaveFileDialog(
        files.length > 1 ? "Zipfile" : files.first.name,
        progress,
        finished,
        onCancel: () async {
          progress.value = null;
          if (status.value != TaskStatus.complete) {
            await downloadFile.cancel();
          }
          if (await downloadFile.file.exists()) {
            await downloadFile.file.delete();
          }
          Get.back();
        },
        onSave: () async {
          final params = SaveFileDialogParams(
              sourceFilePath: downloadFile.file.path,
              fileName: await downloadFile.name);

          final finalPath = await FlutterFileDialog.saveFile(params: params);

          if (finalPath != null) {
            progress.value = null;
            if (await downloadFile.file.exists()) {
              await downloadFile.file.delete();
            }
            Get.back();
            Snackbar.create("Successfully saved file");
          }
        },
      ),
      barrierDismissible: false,
    );

    downloadFile.progress.listen((data) {
      if (data >= 0) {
        progress(data);
      }
    });

    downloadFile.status.listen((data) {
      status(data);
      if (data == TaskStatus.complete) {
        finished(true);
      }
      if (data == TaskStatus.failed || data == TaskStatus.notFound) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Snackbar.createWithTitle(
            "Error", "Error while trying to download file", true);
      }
    });

    if (await downloadFile.success) {
      downloadFile.status.push(TaskStatus.complete);
    } else {
      if (status.value != TaskStatus.canceled) {
        downloadFile.status.push(TaskStatus.failed);
      }
    }
  }

  void createNewFile(String name, bool isFolder) async {
    showProgress(true);
    bool success;
    if (isFolder) {
      success = await FilesApi(params.system).createDir("$path/$name");
    } else {
      success = await FilesApi(params.system).createFile("$path/$name");
    }
    if (success) {
      Snackbar.create("Successfully created ${isFolder ? "folder" : "file"}");
      lazyLoader.refresh();
    } else {
      Snackbar.createWithTitle("Error", "Error while trying to create ${isFolder ? "folder" : "file"}", true);
      showProgress(false);
    }
  }

  //void showNewFileDialog(bool isFolder) {
  //  Get.dialog(widget)
  //}
}