import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/console/console_controller.dart';
import 'package:minecraft_server_remote/values/colors.dart';

import '../../../../generated/l10n.dart';

class ConsoleTab extends StatelessWidget {
  final controller = Get.put(ConsoleController());

  ConsoleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              color: MColors.consoleBackgroundDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Scrollbar(
                          child: Obx(() => SingleChildScrollView(
                            controller: controller.consoleScrollController.value,
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: controller.softwrap.isFalse ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: buildRichText(),
                            ) : buildRichText()
                          )),
                        )
                    ),
                  ],
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Obx(() =>
                TextField(
                  controller: controller.commandTextController.value,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) => controller.handleSend(value, context),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: S.current.command,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_rounded),
                      onPressed: () => controller.handleSend(controller.commandTextController.value.value.text, context),
                    ),
                  ),
                ),
            ),
          )
        ],
      ),
    );
  }

  Padding buildRichText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
          softWrap: controller.softwrap.value,
          text: TextSpan(
              style: GoogleFonts.robotoMono(fontSize: 12),
              children: controller.consoleLog.toList()
          )
      ),
    );
  }
}