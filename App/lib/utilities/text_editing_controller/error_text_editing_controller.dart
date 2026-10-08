import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorTextEditingController extends TextEditingController {
  var errorMessage = Rxn<String>();

  ErrorTextEditingController() {
    addListener(() {
      errorMessage.value = null;
    },);
  }
}