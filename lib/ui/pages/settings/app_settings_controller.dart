import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/main_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/l10n.dart';
import '../../../navigator_key.dart';

class AppSettingsController extends GetxController {

  void donate() async {
    await launchUrl(Uri.parse("https://www.paypal.com/paypalme/christianzaeske/2"));
  }

  void language(context) async {
    var selected = "English".obs;
    await showDialog<ThemeMode>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Design'),
            contentPadding: EdgeInsets.zero,
            content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 16),
                RadioListTile<String>(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: const Text('English'),
                  value: "English",
                  groupValue: selected.value,
                  onChanged: (String? value) {
                    if (value != null) {
                      selected(value);
                    }
                  },
                ),
                RadioListTile<String>(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: const Text('German'),
                  value: "German",
                  groupValue: selected.value,
                  onChanged: (String? value) {
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
                //TODO: UPDATE LANGUAGE
                Navigator.pop(context);
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
            title: const Text('Design'),
            contentPadding: EdgeInsets.zero,
            content: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 16),
                  RadioListTile<ThemeMode>(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: const Text('Use system settings'),
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
                    title: const Text('Light Mode'),
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
                    title: const Text('Dark Mode'),
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