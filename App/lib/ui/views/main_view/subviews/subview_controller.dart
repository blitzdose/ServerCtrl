import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/utilities/api/models/permission.dart';

abstract class SubviewController extends GetxController {
  String system;
  List<Permission> userPermissions;
  Function(List<Widget> actions) onSetActions;
  Function(Widget?) onSetLeading;
  Function(PreferredSizeWidget?) onSetBottom;
  SubviewController({required this.system, required this.userPermissions, required this.onSetActions, required this.onSetLeading, required this.onSetBottom});

  void onShown() {
    onSetActions.call([]);
    onSetLeading.call(null);
    onSetBottom.call(null);
  }

  Future<void> updateData();

  void setFab() {}

  Widget? getLeading() {
    return null;
  }
}