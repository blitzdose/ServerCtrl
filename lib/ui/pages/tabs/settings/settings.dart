import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'settings_controller.dart';

class SettingsTab extends StatelessWidget {
  final controller = Get.put(SettingsController());

  SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Settings");
  }

}