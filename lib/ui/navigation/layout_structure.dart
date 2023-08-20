import 'package:get/get.dart';
import 'package:minecraft_server_remote/utilities/appbar/action_utils.dart';
import 'package:minecraft_server_remote/values/navigation_routes.dart';

import 'navigator.dart';
import 'package:flutter/material.dart';


class LayoutStructure extends StatefulWidget {
  const LayoutStructure({super.key});

  @override
  State<LayoutStructure> createState() => LayoutStructureState();
}

class LayoutStructureState extends State<LayoutStructure> with SingleTickerProviderStateMixin {
  Widget screen = NavigationRoutes.routes.first.route!();

  MNavigator? navigator;

  static ActionUtils controller = Get.put(ActionUtils());

  @override
  Widget build(BuildContext context) {
    navigator ??= MNavigator(onItemTap);
    return Obx(() =>
        Scaffold(
            appBar: controller.action.value != null ? AppBar(
                title: const Text("ServerCtrl", style: TextStyle(fontWeight: FontWeight.w500)),
                actions: [Obx (() => controller.action.value!)]
            ) : AppBar(
                title: const Text("ServerCtrl", style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            drawer: navigator!.buildNavDrawer(),
            floatingActionButton: controller.fab.value.runtimeType != Container ? Obx(() => controller.fab.value) : null,
            body: screen
        )
    );
  }

  void onItemTap(int index) {
    setState(() {
      screen = NavigationRoutes.routes.where((element) => !(element.divider ?? false)).elementAt(index).route!();
      Navigator.pop(context);
    });
  }
}