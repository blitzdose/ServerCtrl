import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/files/files_controller.dart';

class FilesTab extends StatelessWidget {
  final controller = Get.put(FilesController());

  FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Obx(() =>
        Column(
          children: [
            if (controller.showProgress.value) const LinearProgressIndicator(),
            Expanded(
              child: Scrollbar(
                controller: controller.fileScrollController.value,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(height: 0,),
                    padding: EdgeInsets.zero,
                    controller: controller.fileScrollController.value,
                    itemCount: controller.fileEntries.length,
                    itemBuilder: (context, index) =>
                    controller.fileEntries[index]
                ),
              ),
            )
          ],
        )
    );
  }

}