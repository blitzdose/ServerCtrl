import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/values/navigation_routes.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("useDynamicColor", newValue.toString());
  }

  void loadUsesDynamicColor() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? valueString = storage.getString("useDynamicColor");
    if (valueString != null) {
      bool value = bool.parse(valueString);
      usesDynamicColor(value);
    }
  }

  static updateUsesMaterial3(bool newValue) async {
    usesMaterial3(newValue);
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("useMaterial3", newValue.toString());
  }

  void loadUsesMaterial3() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? valueString = storage.getString("useMaterial3");
    if (valueString != null) {
      bool value = bool.parse(valueString);
      usesMaterial3(value);
    }
  }

  static updateThemeMode(ThemeMode themeMode) async {
    MyAppController.themeMode(themeMode);
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("themeMode", themeMode.name);
  }

  void loadThemeMode() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? valueString = storage.getString("themeMode");
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
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("locale", selectedLocale.countryCode != null ? "_${selectedLocale.languageCode}_${selectedLocale.countryCode!}" : selectedLocale.languageCode);
  }

  void loadLocale() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? valueString = storage.getString("locale");
    if (valueString != null) {
      Locale savedLocale;
      if (valueString.startsWith("_")) {
        String languageCode = valueString.substring(1).split("_")[0];
        String countryCode = valueString.substring(1).split("_")[1];
        savedLocale = Locale.fromSubtags(languageCode: languageCode, countryCode: countryCode);
      }  else {
        savedLocale = Locale(valueString);
      }
      locale(savedLocale);
      await Get.updateLocale(savedLocale);
    }
    NavigationRoutes.init();
  }

  static void updateMainColor(Color color) async {
    MyAppController.mainColor(color);
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("mainColor", color.value.toString());
  }

  void loadMainColor() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? valueString = storage.getString("mainColor");
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