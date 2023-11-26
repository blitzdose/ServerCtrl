import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/main_controller.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../components/settings.dart';
import '../../navigation/layout_structure.dart';
import 'app_settings_controller.dart';

class AppSettings extends StatelessWidget {

  final controller = Get.put(AppSettingsController());

  AppSettings({super.key}) {
    LayoutStructureState.controller.fab(Container());
    LayoutStructureState.controller.actions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SettingsList(
        lightTheme: SettingsThemeData(settingsListBackground: Theme.of(context).colorScheme.surface),
        darkTheme: SettingsThemeData(settingsListBackground: Theme.of(context).colorScheme.surface),
        sections: [
          SettingsSection(
            title: const SettingsSectionTitle("Help me"),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: const SettingsTileTitle("Donate"),
                description: const Text("Help me keep this app alive"),
                leading: const Icon(Icons.favorite_outline_rounded),
                onPressed: (context) => controller.donate(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
            ],
          ),
          SettingsSection(
            title: const SettingsSectionTitle("Appearance"),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: const SettingsTileTitle("Language"),
                description: Text("English"), //TODO: GET APP LANGUAGE
                leading: const Icon(Icons.translate_rounded),
                onPressed: (context) => controller.language(context),
              ),
              SettingsTile.navigation(
                title: const SettingsTileTitle("Design"),
                description: Text(MyAppController.themeMode.value.name.capitalizeFirst!),
                leading: const Icon(Icons.dark_mode_rounded),
                onPressed: (context) => controller.design(context),
              ),
              SettingsTile.switchTile(
                title: const SettingsTileTitle("Material 3"),
                leading: const Icon(Icons.design_services_rounded),
                initialValue: MyAppController.usesMaterial3.value,
                onToggle: (bool value) {
                  MyAppController.updateUsesMaterial3(value);
                },
              ),
              SettingsTile.switchTile(
                title: const SettingsTileTitle("Dynamic color"),
                leading: const Icon(Icons.palette_rounded),
                initialValue: MyAppController.usesDynamicColor.value,
                onToggle: (bool value) {
                  MyAppController.updateUsesDynamicColor(value);
                },
              ),
            ],
          ),
          SettingsSection(
            title: const SettingsSectionTitle("Get in touch"),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: const SettingsTileTitle("Discord"),
                leading: const Icon(Icons.discord_rounded),
                onPressed: (context) => controller.discord(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
              SettingsTile.navigation(
                title: const SettingsTileTitle("E-Mail"),
                leading: const Icon(Icons.email_rounded),
                onPressed: (context) => controller.email(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
              SettingsTile.navigation(
                title: const SettingsTileTitle("SpigotMC"),
                leading: const Icon(Icons.language_rounded),
                onPressed: (context) => controller.spigotmc(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
              SettingsTile.navigation(
                title: const SettingsTileTitle("GitHub"),
                leading: const FaIcon(FontAwesomeIcons.github),
                onPressed: (context) => controller.github(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              )
            ],
          ),
          SettingsSection(
            title: SettingsSectionTitle("About"),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: const SettingsTileTitle("Licenses"),
                leading: const Icon(Icons.gavel_rounded),
                onPressed: (context) => showLicensePage(context: context),
              ),
              SettingsTile.navigation(
                title: const SettingsTileTitle("Data privacy"),
                leading: const Icon(Icons.admin_panel_settings_rounded),
                onPressed: (context) => controller.dataPrivacy(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
              SettingsTile.navigation(
                  title: const SettingsTileTitle("About ServerCtrl"),
                  leading: const Icon(Icons.info_rounded),
                  onPressed: (context) => controller.information()
              )
            ],
          )
        ]
      ),
    );
  }

}