import 'package:getxify/rx/src/rx_types/extensions/primitive_extensions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/utilities/api/api.dart';

class MyAccountController extends SubviewController {

  final totpEnabled = false.obs;
  final username = "".obs;
  final showProgress = false.obs;

  MyAccountController({required super.params});

  @override
  Future<void> updateData() async {

  }

  @override
  void onShown() {
    super.onShown();
    params.onSetActions.call(
        [
          IconButton(
              onPressed: () {
                asyncInit();
              },
              icon: const Icon(Icons.refresh_rounded)
          )
        ]
    );
  }

  @override
  void onInit() {
    super.onInit();
    asyncInit();
  }

  Future<void> asyncInit() async {
    showProgress(true);
    username(await UserApi.getUsername());
    totpEnabled(await UserApi.hasTOTP() == true);
    showProgress(false);
  }

  void onChangePassword() {

  }

  void onRemoveTotp() {

  }

  void onSetupTotp() {

  }

}