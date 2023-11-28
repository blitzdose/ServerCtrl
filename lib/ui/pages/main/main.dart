import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/ui/navigation/layout_structure.dart';
import 'package:minecraft_server_remote/utilities/permissions/permissions.dart';

import '../../../generated/l10n.dart';
import '../tabs/tab.dart';
import 'main_controller.dart';

import 'package:minecraft_server_remote/ui/pages/tabs/accounts/accounts.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/console/console.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/files/files.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/home/home.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/players/players.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/settings/settings.dart';
import 'package:minecraft_server_remote/ui/pages/tabs/log/log.dart';

class MainLogin {
  static Future<Main> mainLogin(String baseUrl) async {
    final controller = Get.put(MainController());
    controller.baseURL = baseUrl;
    MainControllerObject object = await controller.init();
    bool success = object.success;
    Permissions permissions = object.permissions;
    return Main(success, permissions);
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

  final Permissions permissions;

  Main(bool success, this.permissions, {super.key}) {
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
      if (permissions.hasPermissionsFor(Permissions.TAB_LOG)) logTab.controller,
      if (permissions.hasPermissionsFor(Permissions.TAB_ACCOUNTS)) accountsTab.controller,
      if (permissions.hasPermissionsFor(Permissions.TAB_SETTINGS)) settingsTab.controller
    ]);
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
              TabBar(
                controller: tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: <Widget>[
                  Tab(
                    icon: const Icon(Icons.home_rounded),
                    text: S.current.home,
                  ),
                  if (permissions.hasPermissionsFor(Permissions.TAB_CONSOLE)) Tab(
                    icon: const Icon(Icons.code_rounded),
                    text: S.current.console,
                  ),
                  if (permissions.hasPermissionsFor(Permissions.TAB_PLAYERS)) Tab(
                    icon: const Icon(Icons.group_rounded),
                    text: S.current.players,
                  ),
                  if (permissions.hasPermissionsFor(Permissions.TAB_FILES)) Tab(
                    icon: const Icon(Icons.folder_rounded),
                    text: S.current.files,
                  ),
                  if (permissions.hasPermissionsFor(Permissions.TAB_LOG)) Tab(
                    icon: const Icon(Icons.notes_rounded),
                    text: S.current.log,
                  ),
                  if (permissions.hasPermissionsFor(Permissions.TAB_ACCOUNTS)) Tab(
                    icon: const Icon(Icons.manage_accounts_rounded),
                    text: S.current.accounts,
                  ),
                  if (permissions.hasPermissionsFor(Permissions.TAB_SETTINGS)) Tab(
                    icon: const Icon(Icons.settings_rounded),
                    text: S.current.settings,
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    homeTab,
                    if (permissions.hasPermissionsFor(Permissions.TAB_CONSOLE)) consoleTab,
                    if (permissions.hasPermissionsFor(Permissions.TAB_PLAYERS)) playersTab,
                    if (permissions.hasPermissionsFor(Permissions.TAB_FILES)) filesTab,
                    if (permissions.hasPermissionsFor(Permissions.TAB_LOG)) logTab,
                    if (permissions.hasPermissionsFor(Permissions.TAB_ACCOUNTS)) accountsTab,
                    if (permissions.hasPermissionsFor(Permissions.TAB_SETTINGS)) settingsTab
                  ],
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