import 'package:flutter/material.dart';

class NavigationRoute {

  final String? id;
  final String? title;
  final Widget? icon;
  final Future<Widget> Function()? route;
  final bool? divider;

  NavigationRoute({
    this.id,
    this.title,
    this.icon,
    this.route,
    this.divider
  });

}