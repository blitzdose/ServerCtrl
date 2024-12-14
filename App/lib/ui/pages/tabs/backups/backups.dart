import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/generated/l10n.dart';


import 'backups_controller.dart';

class BackupTab extends StatelessWidget {
  final controller = Get.put(BackupsController());

  final ScrollController scrollController = ScrollController();

  BackupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  if (controller.showProgress.value) const LinearProgressIndicator() else const SizedBox(height: 4.0),
                  Expanded(
                    child: SizedBox(
                      width: min(700, MediaQuery.of(context).size.width),
                      child: Scrollbar(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: controller.backupItems.isNotEmpty ? ListView(
                            scrollDirection: Axis.vertical,
                            controller: scrollController,
                            children: controller.backupItems.values.toList(),
                          ) :  Center(child: Text(S.current.no_backups),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}