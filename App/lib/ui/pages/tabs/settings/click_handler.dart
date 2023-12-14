import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/pages/tabs/settings/models/server_setting.dart';
import 'package:server_ctrl/ui/pages/tabs/settings/settings_controller.dart';
import 'package:server_ctrl/utilities/dialogs/dialogs.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/l10n.dart';

class ClickHandler {

  ClickHandler(this.controller);

  final SettingsController controller;

  void portClick(RxInt port, BuildContext context) {
    InputDialog(
        title: S.current.port,
        textInputType: TextInputType.number,
        inputFieldText: port.value.toString(),
        inputFieldBorder: const OutlineInputBorder(),
        leftButtonText: S.current.cancel,
        rightButtonText: S.current.ok,
        onRightButtonClick: (text) {
          port(int.parse(text));
          controller.dataChanged(true);
        }).showInputDialog(context);
  }

  void serverClick(RxList<ServerSetting> settings, ServerSetting serverSetting, BuildContext context) {
    InputDialog(
        title: serverSetting.name,
        textInputType: TextInputType.visiblePassword,
        inputFieldText: serverSetting.value,
        inputFieldBorder: const OutlineInputBorder(),
        leftButtonText: S.current.cancel,
        rightButtonText: S.current.ok,
        onRightButtonClick: (text) {
          serverSetting.value = text;
          settings.refresh();
          controller.dataChanged(true);
        }).showInputDialog(context);
  }

  genCert(BuildContext context) {
    InputDialog(
      title: S.current.generateCertificate,
      textInputType: TextInputType.url,
      message: S.current.specifyIpOrAddr,
      leftButtonText: S.current.cancel,
      rightButtonText: S.current.generate,
      onRightButtonClick: (text) {
        controller.generateCert(text);
      }).showInputDialog(context);
  }

  pickCert(BuildContext context) async {
    final certFileName = S.current.noFileSelected.obs;
    final keyFileName = S.current.noFileSelected.obs;

    final Rxn<String> certPath = Rxn<String>();
    final Rxn<String> keyPath = Rxn<String>();

    final Rxn<Uint8List> certBytes = Rxn<Uint8List>();
    final Rxn<Uint8List> keyBytes = Rxn<Uint8List>();

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Text(S.current.uploadCertificate),
            content: SizedBox(
              width: min(500, MediaQuery.of(context).size.width),
              child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(S.current.certificateFile, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text(certFileName.value, softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                      TextButton(onPressed: () async {
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            PlatformFile platformFile = result.files.first;
                            certFileName(platformFile.name);
                            if (kIsWeb) {
                              certBytes(platformFile.bytes);
                            } else {
                              certPath(platformFile.path);
                            }
                          }
                        } on PlatformException catch(_) {
                          Snackbar.createWithTitle(S.current.settings, S.current.pleaseAllowAccessToTheStorage);
                        }
                      }, child: Text(S.current.selectFile))
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Text(S.current.certificateKeyFile, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text(keyFileName.value, softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                      TextButton(onPressed: () async {
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            PlatformFile platformFile = result.files.first;
                            keyFileName(platformFile.name);
                            if (kIsWeb) {
                              keyBytes(platformFile.bytes);
                            } else {
                              keyPath(platformFile.path);
                            }
                          }
                        } on PlatformException catch(_) {
                          Snackbar.createWithTitle(S.current.settings, S.current.pleaseAllowAccessToTheStorage);
                        }
                      }, child: Text(S.current.selectFile))
                    ],
                  )
                ],
              )),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(onPressed: () async {
                    await launchUrl(Uri.parse("https://github.com/blitzdose/ServerCtrl/wiki"), mode: LaunchMode.externalApplication);
                  }, child: Text(S.current.help)),
                  const Spacer(),
                  TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.cancel)),
                  Obx(() => TextButton(onPressed: ((certPath.value != null && keyPath.value != null) || (certBytes.value != null && keyBytes.value != null)) ? () {
                    if (kIsWeb) {
                      controller.uploadCertFromWeb(certBytes.value!, keyBytes.value!);
                    } else {
                      controller.uploadCert(certPath.value!, keyPath.value!);
                    }
                    Navigator.pop(context, true);
                  } : null, child: Text(S.current.upload))),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}