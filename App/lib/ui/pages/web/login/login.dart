import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/navigation/layout_structure.dart';
import 'package:server_ctrl/ui/pages/web/login/login_controller.dart';

import '../../../../generated/l10n.dart';

class LoginWeb extends StatelessWidget {

  final controller = Get.put(LoginController());

  LoginWeb({super.key}) {
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
                    Text("Login", style: const TextStyle(fontSize: 32, ), textAlign: TextAlign.center),
                    const Divider(),
                    const Padding(padding: EdgeInsets.only(top: 48.0)),
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
                    controller.isLoggingIn.isFalse ? FilledButton(
                      onPressed: () {
                        controller.login();
                      },
                      child: Text(S.current.login),
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