import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/navigation/layout_structure.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/l10n.dart';
import '../../../navigator_key.dart';
import 'add_server_controller.dart';

class AddServer extends StatelessWidget {

  final controller = Get.put(AddServerController());

  AddServer({super.key}) {
    LayoutStructureState.controller.fab(Container());
    LayoutStructureState.controller.actions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: SingleChildScrollView(
            child: Obx(() => SizedBox(
              width: min(500, MediaQuery.of(context).size.width),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(S.current.addMinecraftServer, style: const TextStyle(fontSize: 32, ), textAlign: TextAlign.center),
                    const Divider(),
                    Text(S.current.infoInstallPlugin, textAlign: TextAlign.center),
                    const Padding(padding: EdgeInsets.only(top: 48.0)),
                    TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: S.current.serverNameInput
                      ),
                      maxLines: 1,
                      controller: controller.servernameController.value,
                      onChanged: (value) => controller.servernameController.refresh(),
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 24.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "myserver.com:5718"
                            ),
                            maxLines: 1,
                            controller: controller.ipController.value,
                            onChanged: (value) => controller.ipController.refresh(),
                            keyboardType: TextInputType.url,
                            autocorrect: false,
                            enableSuggestions: false,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.isHttps(controller.isHttps.isFalse),
                          child: Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Checkbox(
                                  value: controller.isHttps.value,
                                  onChanged: (value) {
                                    controller.isHttps(value);
                                  }
                              ),
                              Text(S.current.https)
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8.0)),
                    TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: S.current.username
                      ),
                      maxLines: 1,
                      controller: controller.usernameController.value,
                      onChanged: (value) => controller.usernameController.refresh(),
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8.0)),
                    TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: S.current.password
                      ),
                      maxLines: 1,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: controller.passwordController.value,
                      onChanged: (value) => controller.passwordController.refresh(),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) => controller.login(),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 18.0)),
                    if (controller.errorMessage.isNotEmpty) Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red),),
                    const Padding(padding: EdgeInsets.only(top: 18.0)),
                    controller.isLoggingIn.isFalse ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                            onPressed: () {
                              showDialog(
                                context: navigatorKey.currentContext!,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text(S.current.howCanILogIn),
                                      content: Text(S.of(context).howCanILogInText),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(onPressed: () => launchUrl(Uri.parse("https://discord.gg/SewjCwVpaa")), child: Text(S.current.discord)),
                                            TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.ok))
                                          ],
                                        )
                                      ]
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.help_rounded),
                            label: Text(S.current.help)),
                        FilledButton(
                          onPressed: () {
                            controller.login();
                          },
                          child: Text(S.current.login),
                        )
                      ],
                    ) : const CircularProgressIndicator(
                      value: null,
                    )
                  ]
              ),
            ),
            ),
          ),
        )
    );
  }

}