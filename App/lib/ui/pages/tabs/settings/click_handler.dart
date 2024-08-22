import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:server_ctrl/navigator_key.dart';
import 'package:server_ctrl/ui/navigation/layout_structure.dart';
import 'package:server_ctrl/ui/pages/tabs/accounts/accounts.dart';
import 'package:server_ctrl/ui/pages/tabs/log/log.dart';
import 'package:server_ctrl/ui/pages/tabs/settings/models/server_setting.dart';
import 'package:server_ctrl/ui/pages/tabs/settings/settings_controller.dart';
import 'package:server_ctrl/ui/pages/tabs/tab.dart';
import 'package:server_ctrl/utilities/dialogs/dialogs.dart';
import 'package:server_ctrl/utilities/http/http_utils.dart';
import 'package:server_ctrl/utilities/http/session.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/l10n.dart';

class ClickHandler {

  ClickHandler(this.controller);

  final SettingsController controller;

  void changePasswordClick(BuildContext context) {
    TextEditingController passwordTextController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController repeatNewPasswordController = TextEditingController();
    final errorTextPassword = Rxn<String>();
    final emptyCurrentPassword = true.obs;

    final showSpinner = false.obs;
    final showWrongPassword = false.obs;

    errorTextPassword.value = null;
    newPasswordController.text = "";
    repeatNewPasswordController.text = "";
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Text(S.current.changePassword),
            content: SizedBox(
              width: min(500, MediaQuery.of(context).size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Obx(() => TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.current.currentPassword,
                        errorText: (showWrongPassword.value) ? S.current.wrongPassword : null
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordTextController,
                    onChanged: (value) {
                      showWrongPassword(false);
                      if (value.isEmpty) {
                        emptyCurrentPassword(true);
                      } else {
                        emptyCurrentPassword(false);
                      }
                    },
                  )),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.current.newPassword
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    controller: newPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) {
                      if (value != repeatNewPasswordController.text) {
                        errorTextPassword(S.current.passwordsDoNotMatch);
                      } else {
                        errorTextPassword.value = null;
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Obx(() => TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.current.repeatNewPassword,
                        errorText: errorTextPassword.value
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    controller: repeatNewPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) {
                      if (value != newPasswordController.text) {
                        errorTextPassword(S.current.passwordsDoNotMatch);
                      } else {
                        errorTextPassword.value = null;
                      }
                    },
                  )),
                  Obx(() => (showSpinner.value) ? const Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 16)),
                      CircularProgressIndicator(
                        value: null,
                      )
                    ],
                  ) : Container())
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.cancel)),
              Obx(() => TextButton(onPressed: (errorTextPassword.value == null && newPasswordController.text.isNotEmpty && !emptyCurrentPassword.value) ? () async {
                changePassword(showSpinner, passwordTextController, newPasswordController, showWrongPassword, null);
              } : null, child: Text(S.current.changePassword))),
            ],
          ),
        );
      },
    );
  }

  void changePassword(RxBool showSpinner, TextEditingController passwordTextController, TextEditingController newPasswordController, RxBool showWrongPassword, String? code) async {
    showSpinner(true);
    int status = await controller.changePassword(passwordTextController.text, newPasswordController.text, code);
    showSpinner(false);
    if (status == 401) {
      showWrongPassword(true);
    } else if (status == 402) {
      InputDialog(
        title: S.current.twofactorAuthentication,
        textInputType: TextInputType.number,
        message: S.current.pleaseInputYourCode,
        inputFieldHintText: S.current.totpCode,
        inputFieldBorder: const OutlineInputBorder(),
        inputFieldLength: 6,
        inputFieldError: (code != null) ? S.current.wrongCode : null,
        rightButtonText: S.current.login,
        leftButtonText: S.current.cancel,
        onLeftButtonClick: null,
        onRightButtonClick: (text) async {
          changePassword(showSpinner, passwordTextController, newPasswordController, showWrongPassword, text);
        },
      ).showInputDialog(navigatorKey.currentContext!);
    } else if (status == 200) {
      Snackbar.createWithTitle(S.current.account, S.current.passwordChangedSuccessfully);
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  void configureTOTP(BuildContext context) async {
    var dialogRoute = DialogRoute(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(S.current.pleaseWait),
              content: const LinearProgressIndicator(
                value: null,
              ),
            ),
        );
      },
    );
    Navigator.of(navigatorKey.currentContext!).push(dialogRoute);
    bool hasTOTP = await controller.hasTOTP();
    Navigator.of(navigatorKey.currentContext!).pop(dialogRoute);
    if (hasTOTP) {
      showRemoveTOTPDialog(navigatorKey.currentContext!);
    } else {
      showConfigureTOTPDialog(navigatorKey.currentContext!);
    }
  }

  void showRemoveTOTPDialog(BuildContext context) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(S.current.removeTwofactorAuthentication),
        content: Text(S.current.youAlreadyConfigured2FA),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.cancel)),
          TextButton(onPressed: () {
            Navigator.pop(context);
            final textController = TextEditingController().obs;
            final textControllerTOTP = TextEditingController().obs;
            final showPasswordError = false.obs;
            final showTotpError = false.obs;
            final showProgressSpinner = false.obs;
            showGeneralDialog(
              context: context,
              barrierDismissible: false,
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: Text(S.current.inputYourPasswordAndCurrent2fa),
                    content: SizedBox(
                      width: min(500, MediaQuery.of(context).size.width),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(S.of(context).verifyPasswordForRemoving2FA),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          Obx(() => TextField(
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: S.current.password,
                                errorText: showPasswordError.value ? S.current.wrongPassword : null
                            ),
                            maxLines: 1,
                            controller: textController.value,
                            onChanged: (value) {
                              textController.refresh();
                              showPasswordError(false);
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                          )),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          Obx(() => TextField(
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: S.current.totpCode,
                                errorText: showTotpError.value ? S.current.wrongCode : null
                            ),
                            maxLines: 1,
                            maxLength: 6,
                            controller: textControllerTOTP.value,
                            onChanged: (value) {
                              textControllerTOTP.refresh();
                              showTotpError(false);
                            },
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                          )),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          Obx(() => showProgressSpinner.value ? const Center(
                            child: CircularProgressIndicator(
                              value: null,
                            ),
                          ) : Container())
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(onPressed: () {
                        Navigator.pop(context, true);
                      }, child: Text(S.current.cancel)),
                      Obx(() => TextButton(onPressed: textController.value.text.isNotEmpty && textControllerTOTP.value.text.isNotEmpty ? () async {
                        String password = textController.value.text;
                        String code = textControllerTOTP.value.text;
                        showProgressSpinner(true);
                        int result = await controller.removeTOTP(password, code);
                        showProgressSpinner(false);
                        if (result == 401) {
                          showPasswordError(true);
                        } else if (result == 402) {
                          showTotpError(true);
                        } else if (result == 200) {
                          Navigator.pop(navigatorKey.currentContext!, true);
                          Snackbar.createWithTitle(S.current.account, S.current.successfullyRemoved2fa);
                        } else {
                          Navigator.pop(navigatorKey.currentContext!, true);
                          Snackbar.createWithTitle(S.current.account, S.current.errorWhileRemoving2fa, true);
                        }
                      } : null, child: Text(S.current.ok)),)
                    ],
                  ),
                );
              },
            );
          }, child: Text(S.current.remove))
        ],
      );
    },);
  }

  void showConfigureTOTPDialog(BuildContext context) {
    final textController = TextEditingController().obs;
    final showPasswordError = false.obs;
    final showProgressSpinner = false.obs;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Text(S.current.inputYourPassword),
            content: SizedBox(
              width: min(500, MediaQuery.of(context).size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(S.current.pleasePutInYourCurrentPassword),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Obx(() => TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: S.current.password,
                        errorText: showPasswordError.value ? S.current.wrongPassword : null
                    ),
                    maxLines: 1,
                    controller: textController.value,
                    onChanged: (value) {
                      textController.refresh();
                      showPasswordError(false);
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  )),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Obx(() => showProgressSpinner.value ? const Center(
                    child: CircularProgressIndicator(
                      value: null,
                    ),
                  ) : Container())
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(onPressed: () {
                Navigator.pop(context, true);
              }, child: Text(S.current.cancel)),
              Obx(() => TextButton(onPressed: textController.value.text.isNotEmpty ? () async {
                showProgressSpinner(true);
                String? secret = await controller.initTOTP(textController.value.text);
                if (secret == null) {
                  showPasswordError(true);
                  showProgressSpinner(false);
                  return;
                }
                String username = "";
                const storage = FlutterSecureStorage();
                String? creds = await storage.read(key: Session.baseURL);
                if (creds != null) {
                  List<String> credsArr = creds.split("\n");
                  username = credsArr[1];
                }
                showProgressSpinner(false);
                Navigator.pop(navigatorKey.currentContext!);
                final totpTextController = TextEditingController().obs;
                final showtotpError = false.obs;
                showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(S.current.verifyYourTwofactorAuthentication),
                        content: SizedBox(
                          width: min(500, MediaQuery.of(context).size.width),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.current.add2FAtoApp),
                              const Padding(padding: EdgeInsets.only(top: 16)),
                              Center(
                                child: Column(
                                  children: [
                                    QrImageView(
                                      data: "otpauth://totp/ServerCtrl:$username?secret=$secret&issuer=ServerCtrl&algorithm=SHA1&digits=6&period=30",
                                      backgroundColor: Colors.white,
                                      version: QrVersions.auto,
                                      size: 200,
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 16)),
                                    Text("Secret: $secret"),
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 16)),
                              Obx(() => TextField(
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: S.current.totpCode,
                                    errorText: showtotpError.value ? S.current.wrongCode : null
                                ),
                                maxLines: 1,
                                maxLength: 6,
                                controller: totpTextController.value,
                                onChanged: (value) {
                                  totpTextController.refresh();
                                  showtotpError(false);
                                },
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                              )),
                            ],
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: () {
                                Clipboard.setData(ClipboardData(text: secret));
                                Snackbar.createWithTitle(S.current.twofactorAuthentication, S.current.secretCopiedToClipboard);
                              }, child: Text(S.current.copySecret)),
                              TextButton(onPressed: () async {
                                bool success = await controller.verifyTOTP(totpTextController.value.text);
                                if (success) {
                                  Navigator.pop(navigatorKey.currentContext!);
                                  Snackbar.createWithTitle(S.current.twofactorAuthentication, S.current.successfullyAdded2faToYourAccount);
                                } else {
                                  showtotpError(true);
                                }
                              }, child: Text(S.current.confirm))
                            ],
                          )
                        ],
                      );
                    },
                );
              } : null, child: Text(S.current.ok)),)
            ],
          ),
        );
      },
    );
  }

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

  void editableFilesClick(BuildContext context) async {
    var response = await Session.get("/api/files/editable-files");
    if (!HttpUtils.isSuccess(response)) {
      return;
    }

    var fileExtensions = <String>[].obs;
    fileExtensions.addAll(
        (jsonDecode(response.body)["fileExtensions"] as List<dynamic>)
            .map((e) => e.toString()).toList()
    );

    var controller = TextEditingController().obs;
    
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.current.editableFiles),
            content: SizedBox(
              width: min(500, MediaQuery.of(context).size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Obx(() => Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for(var key in fileExtensions)
                        InputChip(
                          label: Text(".$key"),
                          onDeleted: () => fileExtensions.remove(key),
                          onSelected: (value) {},
                        ),
                    ],
                  ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 24)),
                  Obx(() => TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: S.current.newExtension,
                          suffixIcon: controller.value.text.isNotEmpty ? IconButton(onPressed: () {
                            fileExtensions.add(
                                controller.value.text.replaceAll(" ", "")
                                    .replaceAll(".", "")
                            );
                            controller.value.clear();
                          }, icon: const Icon(Icons.add_rounded)) : null
                      ),
                      maxLines: 1,
                      maxLength: 20,
                      controller: controller.value,
                      onChanged: (value) => controller.refresh(),
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context, true);
              }, child: Text(S.current.cancel)),
              TextButton(onPressed: () async {
                Navigator.pop(context, true);
                Map<String, dynamic> data = {
                  "fileExtensions": fileExtensions
                };
                var response = await Session.post("/api/files/editable-files", jsonEncode(data));
                if (HttpUtils.isSuccess(response)) {
                  Snackbar.createWithTitle(S.current.editableFiles, S.current.savedSuccessfully);
                } else {
                  Snackbar.createWithTitle(S.current.editableFiles, S.current.errorWhileSavingChanges, true);
                }
              }, child: Text(S.current.save))
            ],
          );
        });
  }

  void serverClick(RxList<ServerSetting> settings, ServerSetting serverSetting, BuildContext context) {
    InputDialog(
        title: serverSetting.name,
        textInputType: TextInputType.text,
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

  openAccounts(BuildContext context) async {
    AccountsTab accountsTab = AccountsTab();
    await openView(context, accountsTab, accountsTab.controller);
  }

  openLog(BuildContext context) async {
    LogTab logTab = LogTab();
    await openView(context, logTab, logTab.controller);
  }

  openView(BuildContext context, Widget view, TabxController viewController) async {
    viewController.continueTimer();
    viewController.setFab();
    viewController.setAction();

    await showDialog(context: context, builder: (BuildContext context) {
      return Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.current.accounts),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            actions: LayoutStructureState.controller.actions,
          ),
          floatingActionButton: LayoutStructureState.controller.fab.value,
          body: view,
        ),
      );
    });

    LayoutStructureState.controller.fab(Container());
    LayoutStructureState.controller.actions.clear();

    controller.setFab();
    controller.setAction();
  }
}