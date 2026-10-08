import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/generated/l10n.dart';
import 'package:server_ctrl/navigator_key.dart';
import 'package:server_ctrl/ui/views/add_server/add_server_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AddServerView extends GetView<AddServerController> {

  static final String route = "/addserver";

  final passwordVisibilityState = false.obs;

  AddServerView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.server_ctrl, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        body: Center(
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
                              hintText: S.current.serverNameInput,
                              errorText: controller.servernameController.errorMessage.value,
                          ),
                          maxLines: 1,
                          controller: controller.servernameController,
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
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "myserver.com:5718",
                                    errorText: controller.ipController.errorMessage.value,
                                ),
                                maxLines: 1,
                                controller: controller.ipController,
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
                              hintText: S.current.username,
                              errorText: controller.usernameController.errorMessage.value,
                          ),
                          maxLines: 1,
                          controller: controller.usernameController,
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          enableSuggestions: false,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 8.0)),
                        TextField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(onPressed: () {
                                passwordVisibilityState(passwordVisibilityState.isFalse);

                              }, icon: passwordVisibilityState.isFalse ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off_rounded)) ,
                              hintText: S.current.password,
                              errorText: controller.passwordController.errorMessage.value,
                          ),
                          maxLines: 1,
                          obscureText: passwordVisibilityState.isFalse,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: controller.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) => controller.login(),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 18.0)),
                        if (controller.errorMessage.value.isNotEmpty) Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red),),
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
        )
    );
  }

}