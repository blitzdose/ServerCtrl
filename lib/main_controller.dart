import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/values/navigation_routes.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'values/colors.dart';

class MyAppController extends GetxController {

  static var usesDynamicColor = true.obs;
  static var usesMaterial3 = true.obs;
  static var themeMode = ThemeMode.system.obs;
  static var locale = (Get.deviceLocale != null) ? Get.deviceLocale!.obs : const Locale("en").obs;
  static var mainColor = MColors.seed.obs;
  static var appVersion = "".obs;
  static var appName = "ServerCtrl".obs;

  static bool isInitialized = false;

  void init() {
    if (MyAppController.isInitialized) {
      return;
    }
    loadMainColor();
    loadLocale();
    loadThemeMode();
    loadUsesMaterial3();
    loadUsesDynamicColor();
    loadMetadata();
    MyAppController.isInitialized = true;
  }

  static updateUsesDynamicColor(bool newValue) async {
    usesDynamicColor(newValue);
    const storage = FlutterSecureStorage();
    await storage.write(key: "useDynamicColor", value: newValue.toString());
  }

  void loadUsesDynamicColor() async {
    const storage = FlutterSecureStorage();
    String? valueString = await storage.read(key: "useDynamicColor");
    if (valueString != null) {
      bool value = bool.parse(valueString);
      usesDynamicColor(value);
    }
  }

  static updateUsesMaterial3(bool newValue) async {
    usesMaterial3(newValue);
    const storage = FlutterSecureStorage();
    await storage.write(key: "useMaterial3", value: newValue.toString());
  }

  void loadUsesMaterial3() async {
    const storage = FlutterSecureStorage();
    String? valueString = await storage.read(key: "useMaterial3");
    if (valueString != null) {
      bool value = bool.parse(valueString);
      usesMaterial3(value);
    }
  }

  static updateThemeMode(ThemeMode themeMode) async {
    MyAppController.themeMode(themeMode);
    const storage = FlutterSecureStorage();
    await storage.write(key: "themeMode", value: themeMode.name);
  }

  void loadThemeMode() async {
    const storage = FlutterSecureStorage();
    String? valueString = await storage.read(key: "themeMode");
    if (valueString != null) {
      switch(valueString) {
        case "system":
          themeMode(ThemeMode.system);
          break;
        case "light":
          themeMode(ThemeMode.light);
          break;
        case "dark":
          themeMode(ThemeMode.dark);
          break;
      }
    }
  }

  static void updateLanguage(Locale selectedLocale) async {
    locale(selectedLocale);
    locale.refresh();
    const storage = FlutterSecureStorage();
    await storage.write(key: "locale", value: selectedLocale.languageCode);
  }

  void loadLocale() async {
    const storage = FlutterSecureStorage();
    String? valueString = await storage.read(key: "locale");
    if (valueString != null) {
      Locale savedLocale = Locale(valueString);
      locale(savedLocale);
      await Get.updateLocale(savedLocale);
    }
    NavigationRoutes.init();
  }

  static void updateMainColor(Color color) async {
    MyAppController.mainColor(color);
    const storage = FlutterSecureStorage();
    await storage.write(key: "mainColor", value: color.value.toString());
  }

  void loadMainColor() async {
    const storage = FlutterSecureStorage();
    String? valueString = await storage.read(key: "mainColor");
    if (valueString != null) {
      int value = int.parse(valueString);
      mainColor(Color(value));
    }
  }

  void loadMetadata() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion(packageInfo.version);
  }

}