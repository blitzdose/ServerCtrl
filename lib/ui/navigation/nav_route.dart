import 'package:flutter/material.dart';

class NavigationRoute {
  final String? title;
  final IconData? icon;
  final Widget Function()? route;
  final bool? divider;

  NavigationRoute({
    this.title,
    this.icon,
    this.route,
    this.divider
  });

}