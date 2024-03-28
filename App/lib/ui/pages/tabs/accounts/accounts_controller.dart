import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:server_ctrl/navigator_key.dart';
import 'package:server_ctrl/ui/pages/tabs/tab.dart';
import 'package:server_ctrl/utilities/http/session.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';

import '../../../../generated/l10n.dart';
import '../../../../utilities/http/http_utils.dart';
import '../../../navigation/layout_structure.dart';

class AccountsController extends TabxController {

  final accountItems = <Widget>[].obs;
  List<String> permissions = [];

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatNewPasswordController = TextEditingController();
  final errorTextPassword = Rxn<String>();

  AccountsController();

  @override
  Future<http.Response> fetchData() {
    return Session.get("/api/account/all");
  }

  Future<http.Response> fetchPermissions() {
    return Session.get("/api/account/all-permissions");
  }

  @override
  void updateData() async {
    var response = await fetchData();
    var responsePermissions = await fetchPermissions();
    if (HttpUtils.isSuccess(response) && HttpUtils.isSuccess(responsePermissions)) {
      setPermissions(responsePermissions);
      setAccounts(response);
    }
    showProgress(false);
  }

  void setPermissions(http.Response responsePermissions) {
    var permissionsJson = jsonDecode(responsePermissions.body)['permissions'];
    permissions.clear();
    for (var permission in permissionsJson) {
      permissions.add(permission);
    }
    permissions.sort();
  }

  void setAccounts(http.Response response) {
    accountItems.clear();
    var data = jsonDecode(response.body);
    var accounts = data["accounts"];
    for (String account in accounts) {
      accountItems.add(createAccountWidget(account));
    }
  }

  deleteAccountDialog(String accountName) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.deleteAccount),
          content: Text(S.current.deleteAccountMessage(accountName)),
          actions: <Widget>[
            TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.no)),
            TextButton(onPressed: () {
              deleteAccount(accountName);
              Navigator.pop(context, true);
            }, child: Text(S.current.delete)),
          ],
        );
      },
    );
  }

  Future<void> deleteAccount(String accountName) async {
    showProgress(true);
    var response = await Session.post("/api/account/delete", "{\"username\": \"$accountName\"}");
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.accountAndName(accountName), S.current.successfullyDeleted);
    } else {
      Snackbar.createWithTitle(S.current.accountAndName(accountName), S.current.errorDeletingAccount, true);
    }
    updateData();
  }

  resetPasswordDialog(String accountName) {
    errorTextPassword.value = null;
    newPasswordController.text = "";
    repeatNewPasswordController.text = "";
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Text(S.current.resetPassword),
            content: SizedBox(
              width: min(500, MediaQuery.of(context).size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                  ))
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.cancel)),
              Obx(() => TextButton(onPressed: (errorTextPassword.value == null && newPasswordController.text.isNotEmpty) ? () {
                resetPassword(accountName, newPasswordController.text);
                Navigator.pop(context, true);
              } : null, child: Text(S.current.reset))),
            ],
          ),
        );
      },
    );
  }

  Future<void> resetPassword(String accountName, String password) async {
    showProgress(true);
    var response = await Session.post("/api/account/reset-password", "{\"username\": \"$accountName\", \"new-password\": \"${const Base64Encoder.urlSafe().convert(utf8.encode(password)).trim()}\"}");
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.accountAndName(accountName), S.current.successfullyResetPassword);
    }  else {
      Snackbar.createWithTitle(S.current.accountAndName(accountName), S.current.errorResettingPassword, true);
    }
    updateData();
  }

  changePermissionsDialog(String accountName) async {
    showProgress(true);
    final accountPermissions = (await getPermissions(accountName)).obs;
    showProgress(false);
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.only(top: 16),
            title: Text(S.current.permissions),
            content: SizedBox(
              width: min(500, MediaQuery.of(context).size.width),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: permissions.length,
                itemBuilder: (context, index) {
                  return Obx(() => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(permissions[index]),
                      value: accountPermissions[index],
                      onChanged: (value) {
                        if (value != null) {
                          accountPermissions[index] = value;
                        }
                      },
                  ));
                },
              )
            ),
            actions: <Widget>[
              TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.cancel)),
              TextButton(onPressed: () {
                changePermissions(accountName, accountPermissions);
                Navigator.pop(context, true);
              }, child: Text(S.current.save)),
            ],
          ),
        );
      },
    );
  }

  Future<List<bool>> getPermissions(String accountName) async {
    List<bool> checkedPermissions = [];
    var response = await Session.get("/api/account/permissions?username=$accountName");
    if (HttpUtils.isSuccess(response)) {
      List<dynamic> accountPermissions = jsonDecode(response.body)['permissions'];
      for (String permission in permissions) {
          checkedPermissions.add(accountPermissions.contains(permission));
      }
    }
    return checkedPermissions;
  }

  Future<void> changePermissions(String accountName, List<bool> accountPermissions) async {
    Map<String, dynamic> permissionRequestData = {};
    List<Map<String, dynamic>> accountPermissionsMap = [];
    for (int i=0; i<permissions.length; i++) {
      Map<String, dynamic> permissionObject = {
        "name": permissions[i],
        "state": accountPermissions[i]
      };
      accountPermissionsMap.add(permissionObject);
    }
    permissionRequestData["user"] = accountName;
    permissionRequestData["permissions"] = accountPermissionsMap;

    showProgress(true);
    var response = await Session.post("/api/account/permissions", jsonEncode(permissionRequestData));
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(S.current.accountAndName(accountName), S.current.successfullySavedPermissions);
    } else {
      Snackbar.createWithTitle(S.current.accountAndName(accountName), S.current.errorSavingPermissions, true);
    }
    updateData();
  }

  void createAccountDialog() {
    final emptyUsername = true.obs;
    TextEditingController usernameTextController = TextEditingController();

    errorTextPassword.value = null;
    newPasswordController.text = "";
    repeatNewPasswordController.text = "";
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Text(S.current.createAccount),
            content: SizedBox(
              width: min(500, MediaQuery.of(context).size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.current.username
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: usernameTextController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        emptyUsername(true);
                      } else {
                        emptyUsername(false);
                      }
                    },
                  ),
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
                  ))
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.cancel)),
              Obx(() => TextButton(onPressed: (errorTextPassword.value == null && newPasswordController.text.isNotEmpty && !emptyUsername.value) ? () {
                createAccount(usernameTextController.value.text, newPasswordController.text);
                Navigator.pop(context, true);
              } : null, child: Text(S.current.create))),
            ],
          ),
        );
      },
    );
  }

  Future<void> createAccount(String username, String password) async {
    showProgress(true);
    var response = await Session.post("/api/account/create", "{\"username\": \"$username\", \"new-password\": \"${const Base64Encoder.urlSafe().convert(utf8.encode(password)).trim()}\"}");
    if (HttpUtils.isSuccess(response)) {
      Snackbar.createWithTitle(
          S.current.accountAndName(username), S.current.successfullyCreatedNewAccount);
    } else {
      Snackbar.createWithTitle(S.current.accountAndName(username), S.current.errorCreatingAccount);
    }
    updateData();
  }

  Widget createAccountWidget(String accountName) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
                  child: Icon(
                    Icons.person_rounded,
                    size: 32,
                  ),
                )
              ],
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(accountName, style: const TextStyle(fontSize: 24)),
                    OverflowBar(
                      alignment: MainAxisAlignment.end,
                      overflowAlignment: OverflowBarAlignment.end,
                      children: <Widget>[
                        TextButton(
                            onPressed: () => changePermissionsDialog(accountName),
                            child: Text(S.current.permissions)
                        ),
                        TextButton(
                            onPressed: () => resetPasswordDialog(accountName),
                            child: Text(S.current.reset_password)
                        ),
                        TextButton(
                            onPressed: () => deleteAccountDialog(accountName),
                            child: Text(S.current.delete)
                        ),
                      ],
                    )
                  ],
                ),

            )
          ],
        ),
      ),
    );
  }

  @override
  void setAction() {
    LayoutStructureState.controller.actions.clear();
    LayoutStructureState.controller.actions.add(IconButton(
        onPressed: () {
          showProgress(true);
          updateData();
        },
        icon: const Icon(Icons.refresh_rounded)
    ));
  }

  @override
  void setFab() {
    LayoutStructureState.controller.fab(
        FloatingActionButton(
          onPressed: () {
            createAccountDialog();
          },
          child: const Icon(Icons.add_rounded),
        )
    );
  }

  @override
  void continueTimer() {
    updateData();
  }
  @override
  void cancelTimer() {}
}