import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:server_ctrl/utilities/http/download/other_downloader.dart';
import 'package:share_plus/share_plus.dart';

import 'package:universal_html/html.dart' as html;

import '../../../generated/l10n.dart';
import '../../../navigator_key.dart';
import '../../snackbar/snackbar.dart';
import 'android_downloader.dart';

class DownloaderDialog {
  DownloaderDialog(Function(double) onProgress, Function(bool) onFinished);

  startDownload(url, filename, headers) async {
    if (kIsWeb) {
      _downloadWeb(url);
      return;
    }

    var progressPercent = 0.0.obs;
    var status = S.current.downloading.obs;
    var fileSaved = false.obs;
    final String cacheDir = (await getApplicationCacheDirectory()).path;

    var downloader;
    if (Platform.isAndroid) {
      downloader = AndroidDownloader();
      downloader.initialize((progress) {
        progressPercent(progress);
      }, (success) {
        status(success ? S.current.finished : S.current.error);
        fileSaved(true);
      });
      await downloader.download(
          url,
          cacheDir,
          filename,
          headers);
    } else {
      downloader = OtherDownloader();
      downloader.initialize((progress) {
        progressPercent(progress);
      }, (success) {
        status(success ? S.current.finished : S.current.error);
        fileSaved(true);
      });
      await downloader.download(url, cacheDir, filename);
    }

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
                content: Obx(
                  () => !fileSaved.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LinearProgressIndicator(
                              value: progressPercent.value,
                            ),
                            const Padding(padding: EdgeInsets.only(top: 4.0)),
                            Text("${(progressPercent.value * 100).round()} %",
                                textAlign: TextAlign.end)
                          ],
                        )
                      : Text(S.current.downloadedFilenameSuccessfully(
                          filename)),
                ),
                actions: !fileSaved.value
                    ? <Widget>[
                        TextButton(
                            onPressed: () {
                              downloader.cancel();
                              Navigator.pop(context, true);
                            },
                            child: Text(S.current.cancel)),
                      ]
                    : <Widget>[
                        if (Platform.isAndroid || Platform.isIOS)
                          TextButton(
                              onPressed: () async {
                                await Share.shareXFiles([
                                  XFile("$cacheDir/$filename", name: filename)
                                ]);
                              },
                              child: Text(S.current.share)),
                        TextButton(
                            onPressed: () async {
                              status(S.current.saving);
                              fileSaved(false);
                              if (Platform.isAndroid || Platform.isIOS) {
                                var params = SaveFileDialogParams(
                                    sourceFilePath:
                                        "$cacheDir/$filename");
                                String? savedFilePath =
                                    await FlutterFileDialog.saveFile(
                                        params: params);
                                if (savedFilePath != null) {
                                  Snackbar.createWithTitle(
                                      S.current
                                          .fileAndName(filename),
                                      S.current.savedSuccessfully,
                                      false,
                                      5);
                                } else {
                                  Snackbar.createWithTitle(
                                      S.current
                                          .fileAndName(filename),
                                      S.current.errorWhileSavingFile,
                                      true);
                                }
                              } else {
                                String? outputFile =
                                    await FilePicker.platform.saveFile(
                                  fileName: filename,
                                );

                                if (outputFile != null) {
                                  File sourceFile =
                                      File("$cacheDir/$filename");
                                  sourceFile.copy(outputFile);
                                }
                              }
                              fileSaved(true);
                              status(S.current.finished);
                            },
                            child: Text(S.current.saveFile)),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text(S.current.close)),
                      ],
              ),
            ));
      },
    );
  }

  void _downloadWeb(url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
    return;
  }
}
