import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:minecraft_server_remote/ui/navigation/layout_structure.dart';
import 'package:minecraft_server_remote/ui/navigation/navigation_drawer_impl.dart' as my_nav_drawer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../values/navigation_routes.dart';
import '../pages/main/main.dart';
import 'nav_route.dart';

class MNavigator {
  
  int screenIndex = 0;
  final Function(int index, bool pop) onItemTap;
  final Function(int index) onItemLongPress;

  static bool initialSetup = true;

  MNavigator(this.onItemTap, this.onItemLongPress);

  Widget buildNavDrawer() {
    initRoutes();
    var navDrawer = Obx(() => my_nav_drawer.NavigationDrawer(
        onDestinationSelected: (value) => onItemTap_(value, true),
        onLongPressedLocation: (value) => onItemLongPress_(value),
        selectedIndex: screenIndex,
        //indicatorColor: MColors.red_selection,
        indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(50)
            )
        ),
        children: <Widget>[
          buildHeader(),
          ...NavigationRoutes.routes.asMap().entries.map((e) {
            int index = e.key;
            NavigationRoute navRoute = e.value;

            if (navRoute.divider != null && navRoute.divider!) {
              return buildDivider();
            }

            return my_nav_drawer.NavigationDrawerDestination(
                icon: Icon(navRoute.icon, /*color: _getIconColor(screenIndex, index)*/),
                label: Text(navRoute.title!, /*style: _getDrawerTextColor(screenIndex, index)*/)
            );
          }),
        ],
      ),
    );

    return NavigationDrawerTheme(data: const NavigationDrawerThemeData(
        tileHeight: 42.0
    ), child: navDrawer);
  }

  Padding buildHeader() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(28, 44, 16, 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text(
                S.current.server_ctrl,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Text(
                S.current.version("1.0"),
                style: const TextStyle(fontSize: 14),
              ),
              const Padding(padding: EdgeInsets.only(top: 8.0)),
              Divider(),
              Text(
                "Long press entry to delete it",
                style: const TextStyle(fontSize: 14),
              ),
            ]
        ),
      );
  }

  Padding buildDivider() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
      child: Divider(),
    );
  }

  void onItemTap_(int index, bool pop) {
    screenIndex = index;
    onItemTap(index, pop);
  }

  void clickCurrentItem() {
    onItemTap(screenIndex, false);
  }

  void onItemLongPress_(int index) {
    onItemLongPress(index);
  }

  void initRoutes() async {
    if (initialSetup) {
      const storage = FlutterSecureStorage();
      String? servers = await storage.read(key: "servers");
      List<String>? serverList = servers?.split("~*~*~");
      if (serverList == null || serverList.isEmpty) {
        return;
      }
      for (String serverId in serverList) {
        if (serverId.isEmpty) continue;
        String? creds = await storage.read(key: serverId);
        if (creds != null) {
          String name = creds.split("\n")[0];
          if (NavigationRoutes.routes.where((element) => element.id == serverId).isEmpty) {
            NavigationRoutes.routes.insert(
                NavigationRoutes.routes.length-3,
                NavigationRoute(
                    id: serverId,
                    title: name,
                    icon: Icons.dns_rounded,
                    route: () {return MainLogin.mainLogin(serverId);}
                )
            );
          }
        }
      }

      LayoutStructureState.navigator?.onItemTap_(0, false);
      initialSetup = false;
    }
  }
  
}