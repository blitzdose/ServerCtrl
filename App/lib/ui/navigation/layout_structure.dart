import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/navigation/nav_route.dart';
import 'package:server_ctrl/ui/pages/main/main.dart';
import 'package:server_ctrl/utilities/appbar/action_utils.dart';
import 'package:server_ctrl/values/navigation_routes.dart';

import '../../generated/l10n.dart';
import '../../navigator_key.dart';
import 'navigator.dart';
import 'package:flutter/material.dart';


class LayoutStructure extends StatefulWidget {
  const LayoutStructure({super.key});

  @override
  State<LayoutStructure> createState() => LayoutStructureState();
}

class LayoutStructureState extends State<LayoutStructure> with SingleTickerProviderStateMixin {
  Widget screen = Container();

  bool loginRunning = false;

  static MNavigator? navigator;

  static ActionUtils controller = Get.put(ActionUtils());

  bool initDone = false;

  static bool initialized = false;
  static bool needsInit = false;

  LayoutStructureState() {
    if (needsInit) {
      onItemTap(0, false);
    }
  }

  static void init() {
    if (initialized) {
      return;
    }
    if (navigator != null) {
      navigator!.onItemTap_(0, false);
    } else {
      needsInit = true;
    }
    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    navigator ??= MNavigator(onItemTap, onItemLongPress);

    Widget widget = Obx(() =>
        Scaffold(
              appBar: controller.actions.isNotEmpty ? AppBar(
                title: Text(S.current.server_ctrl, style: const TextStyle(fontWeight: FontWeight.w500)),
                actions: controller.actions,
                leading: controller.leading.value,
              ) : AppBar(
                  title: Text(S.current.server_ctrl, style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
              drawer: controller.leading.value == null ? navigator!.buildNavDrawer() : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              floatingActionButton: controller.fab.value.runtimeType != Container ? Obx(() => controller.fab.value) : null,
              body: screen
          ),
    );
    initDone = true;
    return widget;
  }

  void onItemTap(int index, bool pop) async {
    if (loginRunning) {
      return;
    }
    loginRunning = true;
    if (NavigationRoutes.routes.isEmpty) {
      loginRunning = false;
      return;
    }
    if (screen is Main) {
      Main screenMain = screen as Main;
      try {
        for (int i=0; i<screenMain.tabs.length; i++) {
          screenMain.tabs[i].cancelTimer();
        }
      } on Exception catch(_) {}
    }

    final tempScreenFuture = NavigationRoutes.routes.where((element) => !(element.divider ?? false)).elementAt(index).route!();
    Widget tempScreen = Container();
    if (initDone) {
      var dialogRoute = DialogRoute(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(S.current.loggingIn),
              content: const LinearProgressIndicator(
                value: null,
              ),
            ),
          );
        },
      );
      Navigator.of(navigatorKey.currentContext!).push(dialogRoute);
      tempScreen = await tempScreenFuture;
      Navigator.of(navigatorKey.currentContext!).removeRoute(dialogRoute);
    } else {
      tempScreen = await tempScreenFuture;
    }

    setState(() {
      screen = tempScreen;
      if (pop) Navigator.pop(context);
    });
    loginRunning = false;
  }

  void onItemLongPress(int index) async {
    NavigationRoute? route  = NavigationRoutes.routes.where((element) => !(element.divider ?? false)).elementAt(index);
    String? id = route.id;
    if (id != null) {
      await showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.current.deleteRoutetitle(route.title!)),
            content: Text(S.current.selectedEntryWIllBeDeleted),
            actions: <Widget>[
              TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.no)),
              TextButton(onPressed: () async {
                Navigator.pop(context, true);

                const storage = FlutterSecureStorage();
                String? servers = await storage.read(key: "servers");
                List<String>? serverList = servers?.split("~*~*~");
                if (serverList != null && serverList.contains(id)) {
                  serverList.remove(id);
                  await storage.write(key: "servers", value: serverList.join("~*~*~"));
                }
                NavigationRoutes.routes.removeWhere((element) => element.id == id);
                LayoutStructureState.navigator?.onItemTap_(0, false);
              }, child: Text(S.current.delete)),
            ],
          );
        },
      );
    }
  }
}