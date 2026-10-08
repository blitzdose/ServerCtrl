import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/app_settings/app_settings.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/analytics/analytics_controller.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/analytics/analytics_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/console/console_controller.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/console/console_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/files/files_controller.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/files/files_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/logs/logs_controller.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/logs/logs_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/players/players_controller.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/players/players_view.dart';
import 'package:server_ctrl/utilities/api/models/provisioning_client.dart';

import 'main_controller.dart';

class MainView extends GetView<MainController> {
  static final route = "/main";

  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.appBarTitle.value),
          actions: controller.appBarActions.toList(),
          leading: controller.appBarLeading.value,
          bottom: controller.appBarBottom.value,
        ),
        onDrawerChanged: (isOpened) {
          controller.isDrawerOpen(isOpened);
        },
        drawer: NavigationDrawer(
            onDestinationSelected: (value) {
              controller.onDrawerDestinationSelected(context, value);
            },
            selectedIndex: controller.drawerIndex.value,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Client:",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Expanded(
                                child: DropdownButtonFormField<ProvisioningClient>(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              initialValue: controller.currentServer.value,
                              items: controller.servers.map((server) {
                                return DropdownMenuItem(
                                  value: server,
                                  child: Text(server.name,
                                      overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (value) {
                                controller.switchCurrentServer(value);
                              },
                            )),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.add_rounded),
                            onPressed: () {
                              controller.addClient();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded),
                            onPressed: () {
                              controller.loadClients();
                            },
                          ),
                        ],
                      )
                    ]),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Divider(),
              ),
            ] + getDrawerDestinations(controller)),
        body: Obx(() => controller.loggedIn.isFalse ? Center(
            child: CircularProgressIndicator()
        ) : controller.view.value),
      ),
    );
  }

  static List<Widget> getDrawerDestinations(MainController controller) {
    return [
      DrawerDestination(
        icon: Icon(Icons.analytics_rounded),
        label: Text("Analytics"),
        appBarTitle: controller.currentServer.value?.name,
        enabled: controller.currentServer.value != null,
        onSelected: () {
          controller.navigateClient((system, userPermissions, onSetActions, onSetLeading, onSetBottom) => Get.put<AnalyticsController>(AnalyticsController(system: system, userPermissions: userPermissions, onSetActions: onSetActions, onSetLeading: onSetLeading, onSetBottom: onSetBottom)), () => AnalyticsView());
        },
      ),
      DrawerDestination(
        icon: Icon(Icons.code_rounded),
        label: Text("Console"),
        appBarTitle: controller.currentServer.value?.name,
        enabled: controller.currentServer.value != null,
        onSelected: () {
          controller.navigateClient((system, userPermissions, onSetActions, onSetLeading, onSetBottom) => Get.put<ConsoleController>(ConsoleController(system: system, userPermissions: userPermissions, onSetActions: onSetActions, onSetLeading: onSetLeading, onSetBottom: onSetBottom)), () => ConsoleView());
        },
      ),
      DrawerDestination(
        icon: Icon(Icons.group_rounded),
        label: Text("Players"),
        appBarTitle: controller.currentServer.value?.name,
        enabled: controller.currentServer.value != null,
        onSelected: () {
          controller.navigateClient((system, userPermissions, onSetActions, onSetLeading, onSetBottom) => Get.put<PlayersController>(PlayersController(system: system, userPermissions: userPermissions, onSetActions: onSetActions, onSetLeading: onSetLeading, onSetBottom: onSetBottom)), () => PlayersView());
        },
      ),
      DrawerDestination(
        icon: Icon(Icons.folder_rounded),
        label: Text("Files"),
        appBarTitle: controller.currentServer.value?.name,
        enabled: controller.currentServer.value != null,
        onSelected: () {
          controller.navigateClient((system, userPermissions, onSetActions, onSetLeading, onSetBottom) => Get.put<FilesController>(FilesController(system: system, userPermissions: userPermissions, onSetActions: onSetActions, onSetLeading: onSetLeading, onSetBottom: onSetBottom)), () => FilesView());
        },
      ),
      DrawerDestination(
        icon: Icon(Icons.manage_accounts_rounded),
        label: Text("Accounts"),
        appBarTitle: controller.currentBackend.value?.name,
      ),
      DrawerDestination(
        icon: Icon(Icons.notes_rounded),
        label: Text("Logs"),
        appBarTitle: controller.currentBackend.value?.name,
        onSelected: () {
          controller.navigateWithoutClient((system, userPermissions, onSetActions, onSetLeading, onSetBottom) => Get.put<LogsController>(LogsController(system: system, userPermissions: userPermissions, onSetActions: onSetActions, onSetLeading: onSetLeading, onSetBottom: onSetBottom)), () => LogsView());
        },
      ),
      DrawerDestination(
        icon: Icon(Icons.settings_backup_restore_rounded),
        label: Text("Backups"),
        appBarTitle: controller.currentServer.value?.name,
        enabled: controller.currentServer.value != null,
      ),
      DrawerDestination(
        icon: Icon(Icons.build_rounded),
        label: Text("Settings"),
        appBarTitle: controller.currentBackend.value?.name,
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: const Divider(),
      ),
      DrawerDestination(
        icon: Icon(Icons.logout_rounded),
        label: Text("Logout"),
        isExternalButton: true,
        onSelected: () => controller.logout(),
      ),
      DrawerDestination(
        icon: Icon(Icons.settings_rounded),
        label: Text("App Settings"),
        isExternalButton: true,
        onSelected: () {
          Get.toNamed(AppSettingsView.route);
        },
      ),
    ];
  }
}

class DrawerDestination extends NavigationDrawerDestination {

  final Function()? onSelected;
  final String? appBarTitle;
  final bool isExternalButton;

  const DrawerDestination({super.key, required super.icon, required super.label, this.onSelected, super.enabled, this.appBarTitle, this.isExternalButton = false});
}