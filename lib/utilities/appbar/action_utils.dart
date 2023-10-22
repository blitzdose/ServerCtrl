import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionUtils extends GetxController {
  final actions = <Widget>[].obs;
  final leading = Rxn<Widget>();
  final fab = Rx<Widget>(Container());
  final fabVisible = RxBool(true);

  ActionUtils();
}