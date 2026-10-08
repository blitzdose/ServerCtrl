import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:server_ctrl/values/navigation_routes.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:server_ctrl/data_storage/database/storage_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'values/colors.dart';

class MyAppController extends GetxController {

  static var usesDynamicColor = true.obs;
  static var themeMode = ThemeMode.system.obs;
  static var locale = (Get.deviceLocale != null) ? Get.deviceLocale!.obs : const Locale("en").obs;
  static var mainColor = MColors.seed.obs;
  static var appVersion = "".obs;
  static var appName = "ServerCtrl".obs;
  static StorageDatabase storageDatabase = StorageDatabase();

  static bool initStarted = false;
  static final Completer<void> initFinished = Completer<void>();

  void init() {
    if (MyAppController.initStarted) {
      return;
    }
    asyncInit();
    MyAppController.initStarted = true;
  }

  Future<void> asyncInit() async {
    await loadMainColor();
    await loadLocale();
    await loadThemeMode();
    await loadUsesDynamicColor();
    await loadMetadata();
    await loadStorageDatabase();
    initFinished.complete();
  }

  static Future<void> updateUsesDynamicColor(bool newValue) async {
    usesDynamicColor(newValue);
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("useDynamicColor", newValue.toString());
  }

  Future<void> loadUsesDynamicColor() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? valueString = storage.getString("useDynamicColor");
    if (valueString != null) {
      bool value = bool.parse(valueString);
      usesDynamicColor(value);
    }
  }

  static Future<void> updateThemeMode(ThemeMode themeMode) async {
    MyAppController.themeMode(themeMode);
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("themeMode", themeMode.name);
  }

  Future<void> loadThemeMode() async {
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

  static Future<void> updateLanguage(Locale selectedLocale) async {
    locale(selectedLocale);
    locale.refresh();
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("locale", selectedLocale.countryCode != null ? "_${selectedLocale.languageCode}_${selectedLocale.countryCode!}" : selectedLocale.languageCode);
  }

  Future<void> loadLocale() async {
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
    //NavigationRoutes.init();
  }

  static Future<void> updateMainColor(Color color) async {
    MyAppController.mainColor(color);
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("mainColor", color.toARGB32().toString());
  }

  Future<void> loadMainColor() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? valueString = storage.getString("mainColor");
    if (valueString != null) {
      int value = int.parse(valueString);
      mainColor(Color(value));
    }
  }

  Future<void> loadMetadata() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion(packageInfo.version);
  }

  Future<void> loadStorageDatabase() async {
    await storageDatabase.open();
  }

}