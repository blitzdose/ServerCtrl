import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/utilities/api/models/permission.dart';

abstract class SubviewController extends GetxController {
  final SubviewControllerParams params;

  SubviewController({required this.params});

  void onShown() {
    params.onSetActions.call([]);
    params.onSetLeading.call(null);
    params.onSetBottom.call(null);
    params.onSetFloatingActionButton.call(null);
  }

  Future<void> updateData();
}

class SubviewControllerParams {
  final String system;
  final List<Permission> userPermissions;
  final Function(List<Widget> actions) onSetActions;
  final Function(Widget?) onSetLeading;
  final Function(PreferredSizeWidget?) onSetBottom;
  final Function(ExpandableFab?) onSetFloatingActionButton;

  SubviewControllerParams({required this.system, required this.userPermissions, required this.onSetActions, required this.onSetLeading, required this.onSetBottom, required this.onSetFloatingActionButton});
}