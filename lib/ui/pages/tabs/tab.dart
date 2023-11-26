import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:minecraft_server_remote/utilities/permissions/permissions.dart';

import '../../navigation/layout_structure.dart';

abstract class TabxController extends GetxController {

  Timer? timer;
  final showProgress = true.obs;
  Permissions? userPermissions;

  void updateData();
  Future<http.Response> fetchData();

  void setUserPermissions(Permissions permissions) {
    userPermissions = permissions;
  }
  void setAction() {
    LayoutStructureState.controller.actions.clear();
  }

  void setLeading() {
    LayoutStructureState.controller.leading.value = null;
  }

  void setFab() {
    LayoutStructureState.controller.fab(Container());
  }

  void cancelTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  void continueTimer() {
    if (timer == null || !timer!.isActive) {
      updateData();
      timer = Timer.periodic(const Duration(seconds: 5), (timer) => updateData());
    }
  }
}