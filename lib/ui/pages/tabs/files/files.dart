import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/files/files_controller.dart';

class FilesTab extends StatelessWidget {
  final controller = Get.put(FilesController());

  FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Files");
  }

}