import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../values/colors.dart';

class Snackbar {
  static createWithTitle(title, message, [bool isError=false, int duration=2]) {
    Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError ? MColors.minecraftRed.withAlpha(156) : Colors.white.withAlpha(200),
        colorText: isError ? Colors.white : Colors.black,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
        animationDuration: const Duration(milliseconds: 300),
        duration: Duration(seconds: duration)
    );
  }

  static create(message, [bool isError=false, int duration=2]) {
    Get.rawSnackbar(
        messageText: Text(
            message,
            style: TextStyle(
              color: isError ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
        ),
        borderRadius: 15,
        barBlur: 7.0,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError ? MColors.minecraftRed.withAlpha(156) : Colors.white.withAlpha(156),
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
        animationDuration: const Duration(milliseconds: 300),
        duration: Duration(seconds: duration)
    );
  }

}
