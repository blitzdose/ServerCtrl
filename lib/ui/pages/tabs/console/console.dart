import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/console/console_controller.dart';

class ConsoleTab extends StatelessWidget {
  final controller = Get.put(ConsoleController());

  ConsoleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("Console");
  }

}