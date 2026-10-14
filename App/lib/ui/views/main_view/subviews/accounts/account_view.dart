import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/utilities/api/models/permission.dart';
import 'package:server_ctrl/utilities/api/models/provisioning_client.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';

import '../../../../../utilities/dialogs/dialogs.dart';

class AccountView extends StatefulWidget {
  final String accountName;
  final UserPermissions permissions;
  final List<Permission> availablePermissions;
  final List<ProvisioningClient> availableSystems;
  final Function()? onExit;
  final Future<bool> Function(UserPermissions permissions) onSavePermissions;
  final Future<bool> Function(String newPassword) onSavePassword;
  final Future<bool> Function() onDeleteAccount;

  const AccountView({super.key, required this.accountName, required this.permissions, required this.availablePermissions, required this.availableSystems, this.onExit, required this.onSavePermissions, required this.onSavePassword, required this.onDeleteAccount});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final ScrollController scrollController = ScrollController();

  bool showProgress = false;
  bool showSaveButton = false;
  String? passwordErrorText;

  bool passwordEdited = false;
  bool permissionsEdited = false;

  TextEditingController passwordTextController = TextEditingController(text: "********");
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (!passwordEdited && !permissionsEdited) {
          widget.onExit?.call();
          return;
        }

        ConfirmationDialog(
          title: Text("Discard changes?"),
          message: Text("All your changes will be lost"),
          confirmButtonText: "Discard",
          dismissButtonText: "No",
          onConfirm: () {
            Get.back();
            widget.onExit?.call();
          },
          onCanceled: () {
            Get.back();
          },
        ).showConfirmationDialog(context);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.accountName),
            leading: IconButton(
              onPressed: () async {
                if (Get.isSnackbarOpen) {
                  await Get.closeCurrentSnackbar();
                }

                Navigator.maybePop(Get.context!);
              },
              icon: const Icon(Icons.close),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_forever_rounded),
                onPressed: () {
                  ConfirmationDialog(
                    title: Text("Delete ${widget.accountName}?"),
                    message: Text("The account will be deleted forever"),
                    confirmButtonText: "Delete",
                    dismissButtonText: "Cancel",
                    onConfirm: () async {
                      setState(() {
                        showProgress = true;
                      });
                      Get.back();
                      if (await widget.onDeleteAccount()) {
                        widget.onExit?.call();
                      } else {
                        Snackbar.createWithTitle(widget.accountName, "Error while deleting account", true);
                      }
                      setState(() {
                        showProgress = false;
                      });
                    },
                    onCanceled: () {
                      Get.back();
                    },
                  ).showConfirmationDialog(context);
                },
              ),
            ],
          ),
          floatingActionButton: showSaveButton ? FloatingActionButton(
            child: Icon(Icons.save_rounded),
            onPressed: () async {
              setState(() {
                showProgress = true;
              });

              if (passwordEdited) {
                if (passwordTextController.text.isEmpty) {
                  setState(() {
                    passwordErrorText = "Password cannot be empty";
                    showProgress = false;
                  });
                  return;
                }
                if (await widget.onSavePassword(passwordTextController.text)) {
                  setState(() {
                    passwordFocusNode.unfocus();
                    passwordEdited = false;
                    passwordTextController.text = "********";
                  });
                } else {
                  Snackbar.createWithTitle(widget.accountName, "Could not save account", true);
                  setState(() {
                    showProgress = false;
                  });
                  return;
                }
              }
              if (await widget.onSavePermissions(widget.permissions)) {
                showSaveButton = false;
                Get.back();
                Snackbar.createWithTitle(widget.accountName, "Saved successfully");
              } else {
                Snackbar.createWithTitle(widget.accountName, "Could not save account", true);
                setState(() {
                  showProgress = false;
                });
                return;
              }

              setState(() {
                showProgress = false;
              });
            },
          ) : null,
          body: Stack(
            children: [
              Scrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text("Details", style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username"
                          ),
                
                          controller: TextEditingController(text: widget.accountName),
                          enabled: false,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            errorText: passwordErrorText,
                          ),
                          controller: passwordTextController,
                          obscureText: true,
                          maxLines: 1,
                          onChanged: (value) {
                            setState(() {
                              passwordEdited = true;
                              passwordErrorText = null;
                              showSaveButton = true;
                            });
                          },
                          keyboardType: TextInputType.visiblePassword,
                          focusNode: passwordFocusNode,
                          onTap: () {
                            if (passwordTextController.text == "********") {
                              passwordTextController.clear();
                            }
                          },
                        ),
                        CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                          title: Text("Superadmin"),
                          value: widget.permissions.isSuperAdmin,
                          onChanged: (value) {
                            setState(() {
                              widget.permissions.isSuperAdmin = value == true;
                              permissionsEdited = true;
                              showSaveButton = true;
                            });
                          },
                        ),
                        Divider(),
                        Text("Permissions", style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.availableSystems.length,
                          separatorBuilder: (context, index) {
                            return Divider(height: 0, indent: 16,);
                          },
                          itemBuilder: (context, index) {
                            List<Permission> systemPermissions = widget.permissions.systemPermissions[widget.availableSystems[index].name] ?? List.empty();
                            String permissionsStr = "No access";
                            if (widget.permissions.isSuperAdmin) {
                              permissionsStr = "Superadmin";
                            } else if (systemPermissions.contains(Permission.ADMIN)) {
                              permissionsStr = "Admin";
                            } else if (widget.permissions.systemPermissions[widget.availableSystems[index].name]?.contains(Permission.ACCESS) == true) {
                              permissionsStr = "Basic access";
                              if (widget.permissions.systemPermissions[widget.availableSystems[index].name]?.any((e) => e != Permission.ACCESS) == true) {
                                permissionsStr = systemPermissions.where((e) => e != Permission.ACCESS).map((e) => e.name).join(", ");
                              }
                            }

                            return ListTile(
                              enabled: !widget.permissions.isSuperAdmin,
                              title: Text(widget.availableSystems[index].name),
                              subtitle: Text(permissionsStr, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.60)),),
                              onTap: () async {
                                final systemPermissionsMap = <Permission, bool>{}.obs;
                                for (Permission permission in widget.availablePermissions) {
                                  systemPermissionsMap[permission] = systemPermissions.contains(permission);
                                }
                                List<Permission>? newPermissions = await Get.dialog<List<Permission>?>(
                                  AlertDialog(
                                    title: Text(widget.availableSystems[index].name),
                                    content: Obx(() => SizedBox(
                                        width: min(500, MediaQuery.of(context).size.width),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: systemPermissionsMap[Permission.ACCESS] == true ? systemPermissionsMap.entries.length : 1,
                                          itemBuilder: (context, index) {
                                            Permission key = systemPermissionsMap.entries.elementAt(index).key;
                                            return CheckboxListTile(
                                              controlAffinity: ListTileControlAffinity.leading,
                                              title: Text(key.name),
                                              value: systemPermissionsMap[key],
                                              enabled: key == Permission.ADMIN || systemPermissionsMap[Permission.ADMIN] != true,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  systemPermissionsMap[key] = value;
                                                }
                                              },
                                            );
                                          }
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(onPressed: () {
                                        Get.back(result: null);
                                      }, child: Text("Cancel")),
                                      TextButton(onPressed: () {
                                        List<Permission> result = systemPermissionsMap.entries
                                            .where((element) => element.value)
                                            .map((e) => e.key)
                                            .toList();
                                        if (!result.contains(Permission.ACCESS)) {
                                          result = [];
                                        }
                                        Get.back(result: result);
                                      }, child: Text("Save")),
                                    ]
                                  )
                                );
                                if (newPermissions != null) {
                                  setState(() {
                                    widget.permissions.systemPermissions[widget.availableSystems[index].name] = newPermissions;
                                    permissionsEdited = true;
                                    showSaveButton = true;
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (showProgress) LinearProgressIndicator(),
            ],)
      ),
    );
  }
}
