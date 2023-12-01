import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/ui/pages/add_server/add_server.dart';
import 'package:minecraft_server_remote/ui/pages/settings/app_settings.dart';

import '../generated/l10n.dart';
import '../ui/navigation/nav_route.dart';

class NavigationRoutes {
  static final routes = [
    NavigationRoute(title: S.current.add_server, icon: Icons.add_rounded, route: () {return Future(() => AddServer());}),
    NavigationRoute(divider: true),
    NavigationRoute(title: S.current.settings, icon: Icons.settings_rounded, route: () {return Future(() => AppSettings());}),
  ].obs;
}