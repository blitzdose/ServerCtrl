import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../values/colors.dart';

class Snackbar {
  static createWithTitle(title, message, [bool isError=false]) {
    Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError ? MColors.minecraftRed.withAlpha(156) : Colors.black.withAlpha(156),
        colorText: Colors.white,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
        animationDuration: const Duration(milliseconds: 300),
        duration: const Duration(seconds: 2)
    );
  }

  static create(message, [bool isError=false]) {
    Get.rawSnackbar(
        messageText: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
        ),
        borderRadius: 15,
        barBlur: 7.0,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError ? MColors.minecraftRed.withAlpha(156) : Colors.black.withAlpha(156),
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
        animationDuration: const Duration(milliseconds: 300),
        duration: const Duration(seconds: 2)
    );
  }

}