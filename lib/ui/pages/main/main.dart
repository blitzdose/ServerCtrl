import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_server_remote/ui/navigation/layout_structure.dart';

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
    bool success = await controller.init();
    return Main(success);
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

  late final List<TabxController> tabs;

  Main(bool success, {super.key}) {
    loginSuccess = success;
    LayoutStructureState.controller.fab(Container());
    if (!loginSuccess) {
      return;
    }
    tabs = <TabxController>[
      homeTab.controller,
      consoleTab.controller,
      playersTab.controller,
      filesTab.controller,
      logTab.controller,
      accountsTab.controller,
      settingsTab.controller
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (loginSuccess) {
      TabController tabController = TabController(length: 7, vsync: controller);
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
          length: 7,
          child: Column(
            children: <Widget>[
              TabBar(
                controller: tabController,
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    icon: const Icon(Icons.home_rounded),
                    text: S.current.home,
                  ),
                  Tab(
                    icon: const Icon(Icons.code_rounded),
                    text: S.current.console,
                  ),
                  Tab(
                    icon: const Icon(Icons.group_rounded),
                    text: S.current.players,
                  ),
                  Tab(
                    icon: const Icon(Icons.folder_rounded),
                    text: S.current.files,
                  ),
                  Tab(
                    icon: const Icon(Icons.notes_rounded),
                    text: S.current.log,
                  ),
                  Tab(
                    icon: const Icon(Icons.manage_accounts_rounded),
                    text: S.current.accounts,
                  ),
                  Tab(
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
                    consoleTab,
                    playersTab,
                    filesTab,
                    logTab,
                    accountsTab,
                    settingsTab
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
            Text("Connection failed"),
            Padding(padding: EdgeInsets.only(top: 8.0)),
            FilledButton(
              onPressed: () {
                LayoutStructureState.navigator?.clickCurrentItem();
                },
              child: Text("Try again"),
            )
          ],
        ),
      );
    }
  }

  void onTabChanged(int index) {
    tabs[index].setAction();
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