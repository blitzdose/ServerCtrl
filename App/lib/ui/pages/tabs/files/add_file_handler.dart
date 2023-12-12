import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/pages/tabs/files/files_controller.dart';

import '../../../../generated/l10n.dart';
import '../../../../navigator_key.dart';
import '../../../../utilities/dialogs/dialogs.dart';
import '../../../../utilities/http/http_utils.dart';
import '../../../../utilities/http/session.dart';
import '../../../../utilities/snackbar/snackbar.dart';

class AddFileHandler {

  static void createFolderOrFile(FilesController controller, String path, bool isFolder) {
    String title = S.current.createFile;
    String hint = S.current.newFile;
    if (isFolder) {
      title = S.current.createFolder;
      hint = S.current.newFolder;
    }
    InputDialog(
        title: title,
        textInputType: TextInputType.visiblePassword,
        inputFieldHintText: hint,
        inputFieldBorder: const OutlineInputBorder(),
        rightButtonDisableEmpty: true,
        leftButtonText: S.current.cancel,
        rightButtonText: S.current.ok,
        onLeftButtonClick: null,
        onRightButtonClick: (text) {
          _createFileOrFolder(controller, path, text, isFolder);
        }).showInputDialog(Get.context!);
  }

  static void _createFileOrFolder(FilesController controller, String path, String name, bool isFolder) async {
    String url = "/api/files/create-file";
    String successMessage = S.current.successfullyCreatedFile;
    String errorMessage = S.current.errorCreatingFile;
    if (isFolder) {
      url = "/api/files/create-dir";
      successMessage = S.current.successfullyCreatedFolder;
      errorMessage = S.current.errorCreatingFolder;
    }
    controller.showProgress(true);
    Map<String, dynamic> jsonData = {};
    jsonData['path'] = path;
    jsonData['name'] = name;
    var response = await Session.post(url, jsonEncode(jsonData));
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.files, successMessage);
    } else {
      Snackbar.createWithTitle(S.current.files, errorMessage, true);
    }
    controller.updateData(true);
  }

  static uploadFile(FilesController controller, String path) async {
    final pickedFile = RxnString();
    final totalSize = 1.obs;
    final uploadedSize = 0.obs;
    final finished = false.obs;
    final canceled = false.obs;
    pickedFile(S.current.upload);

    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Obx(() => AlertDialog(
          title: Text(pickedFile.string.split("/").last),
          content: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: finished.isFalse ? <Widget>[
              LinearProgressIndicator(
                value: (uploadedSize.value == 0 || uploadedSize.value == totalSize.value) ? null : uploadedSize.value / totalSize.value,
              ),
              const Padding(padding: EdgeInsets.only(top: 4.0)),
              Text("${(uploadedSize.value / totalSize.value * 100).toInt()}%", textAlign: TextAlign.end)
            ] : [
              Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(S.current.filesUploadedSuccessfully)
                  ]
              )
            ],
          )),
          actions: [
            Obx(() =>
                finished.isTrue ? TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(S.current.ok))
             : TextButton(
                  onPressed: () {
                    canceled(true);
                  },
                  child: Text(S.current.cancel),
            ))],
        ));
      },
    );

    final pickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: true
    );

    if (pickerResult != null && pickerResult.files.isNotEmpty) {
      if (pickerResult.files.length > 1) {
        pickedFile(S.current.multipleFiles);
      }  else {
        pickedFile(pickerResult.files.first.name);
      }
      if (kIsWeb) {
        _uploadFileFromWeb(controller, path, pickerResult.files, totalSize, uploadedSize, finished, canceled);
        return;
      }
      _uploadFile(controller, path, pickerResult.files, totalSize, uploadedSize, finished, canceled);
    } else {
      Navigator.pop(navigatorKey.currentContext!, true);
    }
  }

  static void _uploadFile(
      FilesController controller,
      String path,
      List<PlatformFile> platformFiles,
      RxInt totalSize,
      RxInt uploadedSize,
      RxBool finished,
      RxBool canceled) async {

    Map<String, String> files = {};
    for (var element in platformFiles) {
      files[element.name] = element.path!;
    }

    EventSink<List<int>>? sinkCopy;

    canceled.listen((p0) {
      if (p0 && sinkCopy != null) {
        sinkCopy!.close();
        Navigator.pop(navigatorKey.currentContext!, true);
      }
    });

    var response = await Session.postFile("/api/files/upload", path, files, (byteCount, totalLength, isFinished, sink) {
      totalSize(totalLength);
      uploadedSize(byteCount);
      finished(isFinished);
      sinkCopy = sink;
    });
    if (!HttpUtils.isSuccess(response)) {
      Navigator.pop(navigatorKey.currentContext!, true);
      Snackbar.createWithTitle(S.current.files, S.current.errorWhileUploadingFile, true);
    }
    controller.updateData(true);
  }

  static void _uploadFileFromWeb(
      FilesController controller,
      String path,
      List<PlatformFile> platformFiles,
      RxInt totalSize,
      RxInt uploadedSize,
      RxBool finished,
      RxBool canceled) async {

    Map<String, Uint8List> files = {};
    for (var element in platformFiles) {
      files[element.name] = element.bytes!;
    }

    CancelToken cancelToken = CancelToken();

    canceled.listen((p0) {
      //TODO: FIX CANCEL BUTTON
      if (p0) {
        cancelToken.cancel();
      }
    });

    var response = await Session.postFileFromWeb("/api/files/upload", path, files, cancelToken, (byteCount, totalLength, isFinished) {
      totalSize(totalLength);
      uploadedSize(byteCount);
      finished(isFinished);
    });
    if (!HttpUtils.isSuccess(response)) {
      Navigator.pop(navigatorKey.currentContext!, true);
      Snackbar.createWithTitle(S.current.files, S.current.errorWhileUploadingFile, true);
    }
    controller.updateData(true);
  }
}