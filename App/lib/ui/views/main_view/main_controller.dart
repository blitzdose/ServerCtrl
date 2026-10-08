import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/data_storage/database/models/server.dart';
import 'package:server_ctrl/data_storage/database/storage_database.dart';
import 'package:server_ctrl/generated/l10n.dart';
import 'package:server_ctrl/main_controller.dart';
import 'package:server_ctrl/ui/views/add_client/add_client.dart';
import 'package:server_ctrl/ui/views/add_server/add_server.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/ui/views/main_view/widgets.dart';
import 'package:server_ctrl/ui/views/splash_screen/splash_screen.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/api/models/permission.dart';
import 'package:server_ctrl/utilities/api/models/provisioning_client.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';

import 'main_view.dart';

class MainController extends GetxController {
  final Rx<Widget> view = (Container() as Widget).obs;
  final appBarTitle = "".obs;
  final drawerIndex = 0.obs;
  final isDrawerOpen = false.obs;

  late BackendProvider backendProvider;

  final currentBackend = Rxn<Backend>();
  final backends = <Backend>[].obs;

  final currentServer = Rxn<ProvisioningClient>();
  final servers = <ProvisioningClient>[].obs;

  final loggedIn = false.obs;

  Timer? timer;
  SubviewController? currentSubviewController;

  final appBarActions = <Widget>[].obs;
  final appBarLeading = Rxn<Widget>();
  final appBarBottom = Rxn<PreferredSizeWidget>();

  final floatingActionButton = Rxn<FloatingActionButton>();

  UserPermissions userPermissions = UserPermissions(false, {});

  @override
  void onReady() {
    super.onReady();

    backendProvider = BackendProvider(MyAppController.storageDatabase.database);
    asyncInit();

    if (timer == null || !timer!.isActive) {
      currentSubviewController?.updateData();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) => currentSubviewController?.updateData());
    }
  }

  Future<void> asyncInit() async {
    Backend? backend = await backendProvider.getSelectedBackend();
    if (backend == null) {
      Get.offNamed(AddServerView.route);
      return;
    }
    backends.assignAll(await backendProvider.getAll());
    currentBackend(backend);
    appBarTitle(backend.name);

    bool status = await UserApi.publicKeyLogin(currentBackend.value!.username, currentBackend.value!.clientKey);
    loggedIn(status);
    if (!status) {
      Snackbar.create(S.current.connectionFailed, true);
    } else {
      Snackbar.create(S.current.loggingIn);

      UserPermissions? userPermissions = await UserApi.getPermissions();
      if (userPermissions != null) {
        this.userPermissions = userPermissions;
      }

      await loadClients();
    }
  }

  Future<void> loadClients() async {
    var clientList = await ProvisioningApi.list();
    if (clientList == null) {
      Snackbar.create("Unable to load clients");
    } else {
      servers.clear();
      servers.addAll(clientList);
      String? currentServerName = await ClientProvider().getSelectedClient(currentBackend.value!.name);
      if (currentServerName != null) {
        currentServer(servers.firstWhereOrNull((client) => client.name == currentServerName));
      }
      if (currentServer.value == null && servers.isNotEmpty) {
        currentServer(servers.first);
      }
      if (servers.isEmpty) {
        currentServer.value = null;
      }
      if (currentServer.value != null) {
        appBarTitle(currentServer.value!.name);
        ClientProvider().setSelectedClient(currentBackend.value!.name, currentServer.value!.name);
        onDrawerDestinationSelected(navigator!.context, drawerIndex.value);
      } else {
        view(NoServersAddedWidget(this));
      }
    }
  }

  Future<void> logout() async {
    await UserApi.logout();
    backendProvider.delete(currentBackend.value!);
    Get.offNamed(SplashScreenView.route);
  }

  void switchCurrentBackend(Backend? backend) {
    if (backend == null) return;
    if (backend == currentBackend.value) return;
    backendProvider.setSelectedBackend(backend);
    Get.offNamed(SplashScreenView.route);
  }

  Future<void> switchCurrentServer(ProvisioningClient? server) async {
    if (server == null) return;
    if (server == currentServer.value) return;
    await ClientProvider().setSelectedClient(currentBackend.value!.name, server.name);
    currentServer(server);
    appBarTitle(currentServer.value!.name);
    navigator!.pop();
    onDrawerDestinationSelected(navigator!.context, drawerIndex.value);
  }

  void addClient() {
    Get.toNamed(AddClientView.route)?.then((value) => loadClients(),);
  }

  Future<void> navigateClient(SubviewController Function(SubviewControllerParams params) controller, Widget Function() widget) async {
    view(Center(child: CircularProgressIndicator(),));
    var serverData = await ServerApi(currentServer.value!.name).getServerData();
    if (serverData != null) {
      currentSubviewController = controller.call(
        SubviewControllerParams(
            system: currentServer.value!.name,
            userPermissions: userPermissions.getPermissionsForSystem(currentServer.value!.name),
            onSetActions: (List<Widget> actions) => appBarActions.assignAll(actions),
            onSetLeading: (Widget? leading) => appBarLeading.value = leading,
            onSetBottom: (PreferredSizeWidget? onSetBottom) => appBarBottom.value = onSetBottom,
            onSetFloatingActionButton: (FloatingActionButton? onSetFloatingActionButton) => floatingActionButton.value = onSetFloatingActionButton
        )
      );
      currentSubviewController?.onShown();
      currentSubviewController?.updateData();
      view(widget.call());
    } else {
      view(ClientNotConnectedWidget());
      Snackbar.createWithTitle(currentServer.value!.name, "Client is not connected to the server", true);
    }
  }

  Future<void> navigateWithoutClient(SubviewController Function(SubviewControllerParams params) controller, Widget Function() widget) async {
    currentSubviewController = controller.call(
      SubviewControllerParams(
          system: "",
          userPermissions: userPermissions.isSuperAdmin ? Permission.values : [],
          onSetActions: (List<Widget> actions) => appBarActions.assignAll(actions),
          onSetLeading: (Widget? leading) => appBarLeading.value = leading,
          onSetBottom: (PreferredSizeWidget? onSetBottom) => appBarBottom.value = onSetBottom,
          onSetFloatingActionButton: (FloatingActionButton? onSetFloatingActionButton) => floatingActionButton.value = onSetFloatingActionButton
      )
    );
    currentSubviewController?.onShown();
    currentSubviewController?.updateData();
    view(widget.call());
  }

  void onDrawerDestinationSelected(BuildContext context, int value) {
    if (isDrawerOpen.value) {
      Navigator.pop(context);
    }

    DrawerDestination destination = MainView.getDrawerDestinations(this).whereType<DrawerDestination>().elementAt(value);
    destination.onSelected?.call();
    if (destination.appBarTitle != null) {
      appBarTitle(destination.appBarTitle);
    }
    if (!destination.isExternalButton) {
      drawerIndex(value);
    }
  }
}

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }

}