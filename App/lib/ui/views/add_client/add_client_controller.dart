import 'dart:typed_data';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/data_storage/database/models/server.dart';
import 'package:server_ctrl/data_storage/database/storage_database.dart';
import 'package:server_ctrl/generated/l10n.dart';
import 'package:server_ctrl/main_controller.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/http/file.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';

import '../../../utilities/text_editing_controller/error_text_editing_controller.dart';

class AddClientController extends GetxController {
  final isHttps = true.obs;
  final clientnameController = ErrorTextEditingController();
  final ipController = ErrorTextEditingController();

  final errorMessage = "".obs;

  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    asyncInit();
  }

  Future<void> asyncInit() async {
    BackendProvider backendProvider =
        BackendProvider(MyAppController.storageDatabase.database);
    Backend? backend = await backendProvider.getSelectedBackend();
    if (backend != null) {
      ipController.text = backend.ip;
      isHttps(backend.protocol == "https://");
    }
  }

  Future<void> addClient() async {
    isLoading(true);
    String clientName = clientnameController.text;
    String serverUrl = ipController.text;

    if (clientName.isEmpty) {
      clientnameController.errorMessage(S.current.thisFieldIsRequired);
    }
    if (serverUrl.isEmpty) {
      ipController.errorMessage(S.current.thisFieldIsRequired);
    }
    if (clientName.isEmpty || serverUrl.isEmpty) {
      isLoading(false);
      return;
    }

    if (!RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(clientName)) {
      clientnameController.errorMessage("Only Uppercase, Lowercase, Numbers, _ and -");
      isLoading(false);
      return;
    }

    DownloadFile? downloadFile = await ProvisioningApi.add(clientName, (isHttps.value ? "https://" : "http://") + serverUrl);
    if (downloadFile == null || !(await downloadFile.success)) {
      errorMessage("Error while trying to get the provisioning pack");
      isLoading(false);
      return;
    }

    final params = SaveFileDialogParams(
      sourceFilePath: downloadFile.file.path,
      fileName: await downloadFile.name,
    );

    String? path = await FlutterFileDialog.saveFile(params: params);
    if (path != null) {
      Snackbar.create("Successfully provisioned client");
      downloadFile.file.delete();
      navigator!.pop();
    } else {
      await ProvisioningApi.delete(clientName);
    }
    isLoading(false);
  }
}

class AddClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddClientController());
  }
}
