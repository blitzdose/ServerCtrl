import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/components/settings.dart';
import 'package:server_ctrl/ui/pages/tabs/settings/click_handler.dart';
import 'package:server_ctrl/ui/pages/tabs/settings/models/server_setting.dart';
import 'package:server_ctrl/utilities/permissions/permissions.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../../generated/l10n.dart';
import 'settings_controller.dart';

class SettingsTab extends StatelessWidget {
  final controller = Get.put(SettingsController());

  SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    ClickHandler clickHandler = ClickHandler(controller);
    return Obx(() => Column(
      children: [
        if (controller.showProgress.value) const LinearProgressIndicator() else const SizedBox(height: 4.0),
        if (controller.doneLoading.value) Expanded(
          child: SettingsList(
            lightTheme: SettingsThemeData(settingsListBackground: Theme.of(context).colorScheme.surface),
            darkTheme: SettingsThemeData(settingsListBackground: Theme.of(context).colorScheme.surface),
            platform: DevicePlatform.android,
            sections: [
              SettingsSection(
                  title: SettingsSectionTitle(S.current.account),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      title: Text(S.current.changePassword),
                      onPressed: (context) => clickHandler.changePasswordClick(context),
                    ),
                    SettingsTile.navigation(
                      title: Text(S.current.configureTwofactorAuthentication),
                      description: Text(S.current.egWithGoogleAuthenticator),
                      onPressed: (context) => clickHandler.configureTOTP(context),
                    )
                  ]
              ),
              if (controller.userPermissions!.hasPermission(Permissions.PERMISSION_PLUGINSETTINGS)) SettingsSection(
                title: SettingsSectionTitle(S.current.plugin),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      controller.useHttps(value);
                      controller.dataChanged(true);
                    },
                    initialValue: controller.useHttps.value,
                    title: SettingsTileTitle(S.current.https),
                  ),
                  SettingsTile.navigation(
                      title: SettingsTileTitle(S.current.uploadHttpsCertificate),
                      onPressed: (context) => clickHandler.pickCert(context),
                  ),
                  SettingsTile.navigation(
                      title: SettingsTileTitle(S.current.generateNewHttpsCertificate),
                    onPressed: (context) => clickHandler.genCert(context),
                  ),
                  SettingsTile.navigation(
                    title: SettingsTileTitle(S.current.pluginAndWebserverPort),
                    value: Text(controller.port.value.toString()),
                    onPressed: (context) => clickHandler.portClick(controller.port, context),
                  ),
                ],
              ),
              if (controller.userPermissions!.hasPermission(Permissions.PERMISSION_SERVERSETTINGS)) SettingsSection(
                title: SettingsSectionTitle(S.current.server),
                tiles: createTiles(clickHandler)
              )
            ],
          ),
        )
      ],
    ));
  }

  List<AbstractSettingsTile> createTiles(ClickHandler clickHandler) {
    var tiles = <AbstractSettingsTile>[];
    for (int i=0; i<controller.serverSettings.length; i++) {
      if (controller.serverSettings[i].value.runtimeType == bool) {
        tiles.add(SettingsTile.switchTile(
          title: SettingsTileTitle(controller.serverSettings[i].name),
          initialValue: controller.serverSettings[i].value,
          onToggle: (value) {
            controller.serverSettings[i] = ServerSetting(controller.serverSettings[i].name, value);
            controller.dataChanged(true);
          },
        ));
      } else {
        tiles.add(SettingsTile.navigation(
          title: SettingsTileTitle(controller.serverSettings[i].name),
          value: Text(controller.serverSettings[i].value),
          onPressed: (context) {
            clickHandler.serverClick(controller.serverSettings, controller.serverSettings[i], context);
            controller.dataChanged(true);
          },
        ));
      }
    }
    return tiles;
  }
}