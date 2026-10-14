import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/accounts/account_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/accounts/accounts_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/api/models/permission.dart';

import '../../../../../utilities/snackbar/snackbar.dart';

class AccountsController extends SubviewController {

  final showProgress = false.obs;

  final accounts = <String>[].obs;
  final availablePermissions = <Permission>[].obs;

  AccountsController({required super.params});

  @override
  Future<void> updateData() async {

  }

  @override void onShown() {
    super.onShown();
    params.onSetFloatingActionButton(AccountsView.generateFloatingActionButton(this));
  }

  @override
  void onInit() {
    super.onInit();

    asyncInit();
  }

  Future<void> asyncInit() async {
    showProgress(true);
    var accounts = await AccountApi.getAll();
    var availablePermissions = await AccountApi.getAllPermissions();
    if (accounts != null && availablePermissions != null) {
      this.accounts(accounts);
      this.availablePermissions(availablePermissions);
    } else {
      Snackbar.createWithTitle("Error", "Error while fetching accounts", true);
    }
    showProgress(false);
  }

  void showAccount(String account) async {
    showProgress(true);
    var userPermissions = await AccountApi.getUserPermissions(account);
    var availablePermissions = await AccountApi.getAllPermissions();
    var systems = await ProvisioningApi.list();
    if (userPermissions == null || availablePermissions == null || systems == null) {
      Snackbar.createWithTitle("Error", "Error while fetching account details", true);
      showProgress(false);
      return;
    }
    showProgress(false);

    Get.to(() => AccountView(
      accountName: account,
      permissions: userPermissions,
      availablePermissions: availablePermissions,
      availableSystems: systems,
      onExit: () {
        Get.back();
        asyncInit();
      },
      onSavePermissions: (UserPermissions permissions) async {
        return await AccountApi.setPermissions(account, permissions);
      },
      onDeleteAccount: () async {
        return AccountApi.delete(account);
      },
      onSavePassword: (String newPassword) async {
        return await AccountApi.resetPassword(account, newPassword);
      },
    ),
        fullscreenDialog: false);
  }

}