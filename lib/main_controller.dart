import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class MyAppController extends GetxController {

  static var usesDynamicColor = true.obs;
  static var usesMaterial3 = true.obs;
  static var themeMode = ThemeMode.system.obs;

  static var locale = (Get.deviceLocale != null) ? Get.deviceLocale!.obs : Locale("en").obs;

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
      Get.updateLocale(savedLocale);
    }
  }


}