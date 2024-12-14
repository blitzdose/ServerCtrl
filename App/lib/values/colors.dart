import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:server_ctrl/main_controller.dart';

final class MColors {
  static const seed = Color(0xFF2E7D32);

  static const gray = Color(0xFF2D2D2D);
  static const consoleBackgroundDark = Color(0xff0c0e0c);

  static const logSuccess = Color(0xFF327F31);
  static const logDanger = Color(0xFFEE6055);
  static const logWarn = Color(0xFFB39529);
  static const logInfo = Color(0xFF4a6cff);

  static const minecraftDarkRed = Color(0xFFAA0000);
  static const minecraftYellow = Color(0xFFFFFF55);
  static const minecraftBlack = Color(0xFF000000);
  static const minecraftDarkGray = Color(0xFF555555);
  static const minecraftGray = Color(0xFFAAAAAA);
  static const minecraftWhite = Color(0xFFFFFFFF);
  static const minecraftDarkPurple = Color(0xFFAA00AA);
  static const minecraftLitPurple = Color(0xFFFF55FF);
  static const minecraftBlue = Color(0xFF5555FF);
  static const minecraftDarkBlue = Color(0xFF0000AA);
  static const minecraftDarkAqua = Color(0xFF00AAAA);
  static const minecraftAqua = Color(0xFF55FFFF);
  static const minecraftGreen = Color(0xFF55FF55);
  static const minecraftDarkGreen = Color(0xFF00AA00);
  static const minecraftGold = Color(0xFFFFAA00);
  static const minecraftRed = Color(0xFFFF5555);

  static Color cardTint(BuildContext context) {
    return MyAppController.themeMode.value == ThemeMode.light ? Theme.of(context).primaryColorDark : Theme.of(context).primaryIconTheme.color!;

  }
}