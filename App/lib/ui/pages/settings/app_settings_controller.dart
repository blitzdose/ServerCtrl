import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/main_controller.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/l10n.dart';
import '../../../navigator_key.dart';
import '../../../values/colors.dart';

class AppSettingsController extends GetxController {

  void donate() async {
    await launchUrl(Uri.parse("https://www.paypal.com/paypalme/christianzaeske/2"));
  }

  void language(context) async {
    var locales = S.delegate.supportedLocales.obs;
    var selectedLocale = MyAppController.locale.value.obs;
    for (var locale in locales) {
      if (locale.languageCode == MyAppController.locale.value.languageCode) {
        selectedLocale = locale.obs;
        break;
      }
    }
    await showDialog<Locale>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.current.language),
            contentPadding: EdgeInsets.zero,
            content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 16),
                for(Locale locale in locales)
                  RadioListTile<Locale>(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(LocaleNames.of(context)!.nameOf(locale.languageCode)!),
                    value: locale,
                    groupValue: selectedLocale.value,
                    onChanged: (Locale? value) {
                      if (value != null) {
                        selectedLocale(value);
                      }
                    },
                  ),
                const SizedBox(height: 24),
              ],
            ),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text(S.current.cancel)),
              TextButton(onPressed: () {
                MyAppController.updateLanguage(selectedLocale.value);
                Get.updateLocale(selectedLocale.value);
                Navigator.pop(context);
                Snackbar.createWithTitle(S.current.server_ctrl, S.current.restartToApplyLanguage);
              }, child: Text(S.current.save)),
            ],
          );
        }
    );

  }

  void design(context) async {
    var selected = MyAppController.themeMode.value.obs;
    await showDialog<ThemeMode>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.current.design),
            contentPadding: EdgeInsets.zero,
            content: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 16),
                  RadioListTile<ThemeMode>(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(S.current.useSystemSettings),
                    value: ThemeMode.system,
                    groupValue: selected.value,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        selected(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(S.current.lightMode),
                    value: ThemeMode.light,
                    groupValue: selected.value,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        selected(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(S.current.darkMode),
                    value: ThemeMode.dark,
                    groupValue: selected.value,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        selected(value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text(S.current.cancel)),
              TextButton(onPressed: () {
                MyAppController.updateThemeMode(selected.value);
                Navigator.pop(context);
              }, child: Text(S.current.save)),
            ],
          );
        }
    );
  }

  void color(BuildContext context) {
    var selectedColor = MyAppController.mainColor.value.obs;
    Color initialColor = MyAppController.mainColor.value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.themeColor),
          content: Obx(() => MaterialColorPicker(
              selectedColor: selectedColor.value,
              onColorChange: (value) {
                selectedColor(value);
                MyAppController.updateMainColor(selectedColor.value);
              },
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(onPressed: () {
                  selectedColor(MColors.seed);
                  MyAppController.updateMainColor(selectedColor.value);
                }, child: Text(S.current.defaultStr)),
                const Spacer(),
                TextButton(onPressed: () {
                  MyAppController.updateMainColor(initialColor);
                  Navigator.pop(context, true);
                }, child: Text(S.current.cancel)),
                TextButton(onPressed: () {
                  MyAppController.updateMainColor(selectedColor.value);
                  Navigator.pop(context, true);
                }, child: Text(S.current.save)),
              ],
            )
          ],
        );
      },
    );
  }

  void discord() async {
    await launchUrl(Uri.parse("https://discord.gg/SewjCwVpaa"));
  }

  void email() async {
    await launchUrl(Uri.parse("mailto:christian@blitzdose.de"));
  }

  void spigotmc() async {
    await launchUrl(Uri.parse("https://www.spigotmc.org/resources/serverctrl.72231/"));
  }

  void github() async {
    await launchUrl(Uri.parse("https://github.com/blitzdose/ServerCtrl"));
  }

  void dataPrivacy() async {
    await launchUrl(Uri.parse("https://blitzdose.de/server-remote/privacy-policy/"));
  }

  void information() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.dns_rounded, size: 48),
              const Padding(padding: EdgeInsets.only(right: 24)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.current.server_ctrl, style: const TextStyle(fontSize: 24),),
                  Text(packageInfo.version, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),)
                ],
              )
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.current.codedBy("Christian Zäske")),
              const Padding(padding: EdgeInsets.only(top: 8)),
              Text(S.current.thanks)
            ],
          ),
          actions: <Widget>[
            TextButton(onPressed: () {
              Navigator.pop(context, true);
            }, child: Text(S.current.close)),
          ],
        );
      },
    );
  }
}