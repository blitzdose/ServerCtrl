import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';

class ActionUtils extends GetxController {
  final actions = <Widget>[].obs;
  final leading = Rxn<Widget>();
  final fab = Rx<Widget>(Container());
  final fabVisible = RxBool(true);
  final title = S.current.server_ctrl.obs;

  ActionUtils();
}