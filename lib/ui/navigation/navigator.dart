import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../values/colors.dart';
import '../../values/navigation_routes.dart';
import 'nav_route.dart';

class MNavigator {
  
  int screenIndex = 0;
  final Function(int index) onItemTap;

  MNavigator(this.onItemTap);

  Widget buildNavDrawer() {
    var navDrawer = NavigationDrawer(
      onDestinationSelected: _onItemTap,
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

          return NavigationDrawerDestination(
              icon: Icon(navRoute.icon, /*color: _getIconColor(screenIndex, index)*/),
              label: Text(navRoute.title!, /*style: _getDrawerTextColor(screenIndex, index)*/)
          );
        }),
      ],
    );

    return NavigationDrawerTheme(data: const NavigationDrawerThemeData(
        tileHeight: 42.0
    ), child: navDrawer);
  }

  Padding buildHeader() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(28, 44, 16, 24),
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
              )
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

  void _onItemTap(int index) {
    screenIndex = index;
    onItemTap(index);
  }

  TextStyle? _getDrawerTextColor(int screenIndex, int actualIndex) {
    if (screenIndex == actualIndex) {
      return const TextStyle(/*color: MColors.red*/);
    }
    return null;
  }

  Color? _getIconColor(int screenIndex, int actualIndex) {
    if (screenIndex == actualIndex) {
      return MColors.seed;
    }
    return null;
  }
  
}