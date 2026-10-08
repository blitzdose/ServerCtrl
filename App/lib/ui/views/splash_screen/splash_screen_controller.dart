import 'package:get/get.dart';
import 'package:server_ctrl/data_storage/database/models/server.dart';
import 'package:server_ctrl/data_storage/database/storage_database.dart';
import 'package:server_ctrl/main_controller.dart';
import 'package:server_ctrl/ui/views/add_server/add_server.dart';
import 'package:server_ctrl/ui/views/main_view/main_view.dart';

import '../../../utilities/http/session.dart';

class SplashScreenController extends GetxController {

  @override
  void onReady() {
    super.onReady();

    asyncInit();
  }

  Future<void> asyncInit() async {
    await MyAppController.initFinished.future;

    BackendProvider serverProvider = BackendProvider(MyAppController.storageDatabase.database);
    List<Backend> servers = await serverProvider.getAll();
    Backend? currentServer = await serverProvider.getSelectedBackend();

    if (servers.isEmpty) {
      Get.offNamed(AddServerView.route);
    } else {
      if (currentServer == null) {
        await serverProvider.setSelectedBackend(servers.first);
        currentServer = servers.first;
      }
      Session.setBaseURL(currentServer.protocol + currentServer.ip);
      Get.offNamed(MainView.route);
    }
  }
}

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
  }
}
