import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/navigation/layout_structure.dart';
import 'package:server_ctrl/utilities/permissions/permissions.dart';

import '../../../generated/l10n.dart';
import '../tabs/tab.dart';
import 'main_controller.dart';

import 'package:server_ctrl/ui/pages/tabs/accounts/accounts.dart';
import 'package:server_ctrl/ui/pages/tabs/console/console.dart';
import 'package:server_ctrl/ui/pages/tabs/files/files.dart';
import 'package:server_ctrl/ui/pages/tabs/home/home.dart';
import 'package:server_ctrl/ui/pages/tabs/players/players.dart';
import 'package:server_ctrl/ui/pages/tabs/settings/settings.dart';
import 'package:server_ctrl/ui/pages/tabs/log/log.dart';

class MainLogin {
  static Future<Main> mainLogin(String baseUrl, String name) async {
    final controller = Get.put(MainController());
    controller.baseURL = baseUrl;
    MainControllerObject object = await controller.init();
    bool success = object.success;
    Permissions permissions = object.permissions;
    return Main(success, permissions, name);
  }
}

class Main extends StatelessWidget {

  final controller = Get.put(MainController());

  late final bool loginSuccess;

  final homeTab = HomeTab();
  final consoleTab = ConsoleTab();
  final playersTab = PlayersTab();
  final filesTab = FilesTab();
  final logTab = LogTab();
  final accountsTab = AccountsTab();
  final settingsTab = SettingsTab();

  final List<TabxController> tabs = [];
  final List<Widget> tabViews = [];

  final Permissions permissions;

  final String name;

  Main(bool success, this.permissions, this.name, {super.key}) {
    loginSuccess = success;
    LayoutStructureState.controller.fab(Container());
    if (!loginSuccess) {
      return;
    }
    tabs.clear();
    tabs.addAll(<TabxController>[
      homeTab.controller,
      if (permissions.hasPermissionsFor(Permissions.TAB_CONSOLE)) consoleTab.controller,
      if (permissions.hasPermissionsFor(Permissions.TAB_PLAYERS)) playersTab.controller,
      if (permissions.hasPermissionsFor(Permissions.TAB_FILES)) filesTab.controller,
      settingsTab.controller
    ]);

    tabViews.clear();
    tabViews.addAll([
      homeTab,
      if (permissions.hasPermissionsFor(Permissions.TAB_CONSOLE)) consoleTab,
      if (permissions.hasPermissionsFor(Permissions.TAB_PLAYERS)) playersTab,
      if (permissions.hasPermissionsFor(Permissions.TAB_FILES)) filesTab,
      settingsTab
    ]);

    onTabChanged(0);
    LayoutStructureState.controller.title(name);
    LayoutStructureState.controller.bottomNavigationBar(
      Obx(() =>
        NavigationBar(
          onDestinationSelected: (int index) {
            onTabChanged(index);
            controller.selectedIndex(index);
          },
          selectedIndex: controller.selectedIndex.value,
          destinations: <Widget>[
            NavigationDestination(
              icon: const Icon(Icons.home_rounded),
              label: S.current.home,
            ),
            if (permissions.hasPermissionsFor(Permissions.TAB_CONSOLE)) NavigationDestination(
                icon: const Icon(Icons.code_rounded),
                label: S.current.console
            ),
            if (permissions.hasPermissionsFor(Permissions.TAB_PLAYERS)) NavigationDestination(
                icon: const Icon(Icons.group_rounded),
                label: S.current.players
            ),
            if (permissions.hasPermissionsFor(Permissions.TAB_FILES)) NavigationDestination(
                icon: const Icon(Icons.folder_rounded),
                label: S.current.files
            ),
            NavigationDestination(
                icon: const Icon(Icons.settings_rounded),
                label: S.current.settings
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loginSuccess) {
      TabController tabController = TabController(length: permissions.getTabCount(), vsync: controller);
      tabController.addListener(() {
        if (tabController.indexIsChanging) {
          onTabChanged(tabController.index);
        } else if (tabController.index != tabController.previousIndex) {
          onTabChanged(tabController.index);
        }
      });
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: DefaultTabController(
          length: permissions.getTabCount(),
          child: Column(
            children: <Widget>[
              Obx(() => Expanded(
                    child: tabViews.isNotEmpty ? tabViews[controller.selectedIndex.value] : homeTab
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.current.connectionFailed),
            const Padding(padding: EdgeInsets.only(top: 8.0)),
            FilledButton(
              onPressed: () {
                LayoutStructureState.navigator?.clickCurrentItem();
                },
              child: Text(S.current.tryAgain),
            )
          ],
        ),
      );
    }
  }

  void onTabChanged(int index) {
    tabs[index].setAction();
    tabs[index].setUserPermissions(permissions);
    tabs[index].setLeading();
    tabs[index].setFab();
    tabs[index].continueTimer();
    for (int i=0; i<tabs.length; i++) {
      if (i != index) {
        tabs[i].cancelTimer();
      }
    }
  }
}