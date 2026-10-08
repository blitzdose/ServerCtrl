import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/generated/l10n.dart';

import '../../../navigator_key.dart';
import 'add_client_controller.dart';

class AddClientView extends GetView<AddClientController> {
  static final String route = "/addclient";

  const AddClientView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      appBar: AppBar(
        title: Text("Provision client", style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 24,
            children: [
              Text("By filling out the information below, you can generate a \"provisioning pack\", which you can use to add a client to this server.\n\nPlease note, that the client needs to be able to reach the Server URL you specify. Usually this is the same you used to connect to the server from this app."),
              Divider(),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Client name (freely selectable)",
                  errorText: controller.clientnameController.errorMessage.value,
                ),
                maxLines: 1,
                controller: controller.clientnameController,
                keyboardType: TextInputType.name,
                autocorrect: false,
                enableSuggestions: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Server URL",
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
              if (controller.errorMessage.value.isNotEmpty) Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red),),
              controller.isLoading.isFalse ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      controller.addClient();
                    },
                    child: Text("Get provisioning file"),
                  )
                ],
              ) : const CircularProgressIndicator(
                value: null,
              )
            ],
          ),
        ),
      ),
    );
  }

}