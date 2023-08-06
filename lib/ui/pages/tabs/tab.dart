import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../navigation/layout_structure.dart';

abstract class LayoutTab extends GetxController {

  Timer? timer;
  final showProgress = true.obs;

  void updateData();
  Future<http.Response> fetchData();

  void setAction() {
    LayoutStructureState.controller.action.value = null;
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