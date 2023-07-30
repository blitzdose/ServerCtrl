import 'package:flutter/material.dart';
import 'package:minecraft_server_remote/ui/pages/main/main.dart';

import '../generated/l10n.dart';
import '../ui/navigation/nav_route.dart';

class NavigationRoutes {
  static List<NavigationRoute> routes = [
    NavigationRoute(title: S.current.add_server, icon: Icons.add_rounded, route: () {return Main();}),
    NavigationRoute(divider: true),
    NavigationRoute(title: S.current.settings, icon: Icons.settings_rounded, route: () {return Main();}),
  ];
}