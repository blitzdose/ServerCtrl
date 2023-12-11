import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/pages/add_server/add_server.dart';
import 'package:server_ctrl/ui/pages/settings/app_settings.dart';

import '../generated/l10n.dart';
import '../ui/navigation/nav_route.dart';
import '../ui/pages/web/login/login.dart';

class NavigationRoutes {

  static final routes = <NavigationRoute>[].obs;

  static void init() {
    if (kIsWeb) {
      routes([
        NavigationRoute(title: "Control", icon: Icons.dns_rounded, route: () {return Future(() => LoginWeb());}),
        NavigationRoute(divider: true),
        NavigationRoute(title: S.current.settings, icon: Icons.settings_rounded, route: () {return Future(() => AppSettings());}),
      ]);
      return;
    }  
    routes([
      NavigationRoute(title: S.current.add_server, icon: Icons.add_rounded, route: () {return Future(() => AddServer());}),
      NavigationRoute(divider: true),
      NavigationRoute(title: S.current.settings, icon: Icons.settings_rounded, route: () {return Future(() => AppSettings());}),
    ]);
  }
}