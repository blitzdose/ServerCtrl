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

  @override
  Widget build(BuildContext context) {
    navigator ??= MNavigator(onItemTap);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ServerCtrl", style: TextStyle(fontWeight: FontWeight.w500)),
        //actions: <Widget>[
        //  IconButton(
        //      onPressed: () {
        //        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("data")));
        //      },
        //      icon: const Icon(Icons.refresh_rounded))
        //],
      ),
      drawer: navigator!.buildNavDrawer(),
      body: screen
    );
  }

  void onItemTap(int index) {
    setState(() {
      screen = NavigationRoutes.routes.where((element) => !(element.divider ?? false)).elementAt(index).route!();
      Navigator.pop(context);
    });
  }
}