import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/main_controller.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../generated/l10n.dart';
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
            title: SettingsSectionTitle(S.current.helpMe),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.donate),
                description: Text(S.current.helpMeKeepThisAppAlive),
                leading: const Icon(Icons.favorite_outline_rounded),
                onPressed: (context) => controller.donate(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
            ],
          ),
          SettingsSection(
            title: SettingsSectionTitle(S.current.appearance),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.language),
                description: Text(LocaleNames.of(context)!.nameOf(MyAppController.locale.value.languageCode)!),
                leading: const Icon(Icons.translate_rounded),
                onPressed: (context) => controller.language(context),
              ),
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.design),
                description: Text(MyAppController.themeMode.value.name.capitalizeFirst!),
                leading: const Icon(Icons.dark_mode_rounded),
                onPressed: (context) => controller.design(context),
              ),
              SettingsTile.switchTile(
                title: SettingsTileTitle(S.current.material3),
                leading: const Icon(Icons.design_services_rounded),
                initialValue: MyAppController.usesMaterial3.value,
                onToggle: (bool value) {
                  MyAppController.updateUsesMaterial3(value);
                },
              ),
              SettingsTile.switchTile(
                title: SettingsTileTitle(S.current.dynamicColor),
                leading: const Icon(Icons.wallpaper_rounded),
                initialValue: MyAppController.usesDynamicColor.value,
                onToggle: (bool value) {
                  MyAppController.updateUsesDynamicColor(value);
                },
              ),
              SettingsTile.navigation(
                enabled: !MyAppController.usesDynamicColor.value,
                title: SettingsTileTitle(S.current.themeColor),
                leading: const Icon(Icons.palette_rounded),
                onPressed: (context) => controller.color(context),
                trailing: CircleColor(
                  color: (MyAppController.usesDynamicColor.isTrue) ? MyAppController.mainColor.value.withOpacity(0.3) : MyAppController.mainColor.value,
                  circleSize: 36,
                ),
              ),
            ],
          ),
          SettingsSection(
            title: SettingsSectionTitle(S.current.getInTouch),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.discord),
                leading: const Icon(Icons.discord_rounded),
                onPressed: (context) => controller.discord(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.email),
                leading: const Icon(Icons.email_rounded),
                onPressed: (context) => controller.email(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.spigotmc),
                leading: const Icon(Icons.language_rounded),
                onPressed: (context) => controller.spigotmc(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.github),
                leading: const FaIcon(FontAwesomeIcons.github),
                onPressed: (context) => controller.github(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              )
            ],
          ),
          SettingsSection(
            title: SettingsSectionTitle(S.current.about),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.licenses),
                leading: const Icon(Icons.gavel_rounded),
                onPressed: (context) => showLicensePage(context: context),
              ),
              SettingsTile.navigation(
                title: SettingsTileTitle(S.current.dataPrivacy),
                leading: const Icon(Icons.admin_panel_settings_rounded),
                onPressed: (context) => controller.dataPrivacy(),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16,),
              ),
              SettingsTile.navigation(
                  title: SettingsTileTitle(S.current.aboutServerctrl),
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