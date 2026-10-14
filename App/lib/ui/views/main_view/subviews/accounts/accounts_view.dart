import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/accounts/accounts_controller.dart';
import 'package:server_ctrl/values/colors.dart';

class AccountsView extends StatelessWidget {
  final controller = Get.find<AccountsController>();

  final ScrollController scrollController = ScrollController();

  AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Stack(
          children: [
            SizedBox(
              child: Scrollbar(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.asyncInit();
                    },
                    child: ListView.builder(
                      itemCount: controller.accounts.length,
                      itemBuilder: (context, index) {
                        return AccountRow(
                          accountName: controller.accounts[index],
                          onTap: () => controller.showAccount(controller.accounts[index]),
                        );
                        //return PlayerRow(
                        //  player: controller.players[index],
                        //  serverType: controller.serverType.value,
                        //  userPermissions: controller.params.userPermissions,
                        //  onCommand: (command) => controller.sendCommand(controller.players[index], command),
                        //);
                      },
                    ),
                  ),
                )
              ),
            ),
            if (controller.showProgress.value) const LinearProgressIndicator() else const SizedBox(height: 4.0),
          ],
        )
    );
  }

  static FloatingActionButton generateFloatingActionButton(var controller) {
    return FloatingActionButton(
      child: Icon(Icons.add_rounded),
      onPressed: () {
        final usernameTextController = TextEditingController().obs;
        final passwordTextController = TextEditingController().obs;
        Get.dialog(
          barrierDismissible: false,
          AlertDialog(
            title: Text("Create account"),
            content: Obx(() => Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                      ),
                      errorText: null,
                      labelText: "Username"
                  ),
                  maxLines: 1,
                  controller: usernameTextController.value,
                  onChanged: (value) => usernameTextController.refresh(),
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: null,
                      labelText: "Password",
                  ),
                  maxLines: 1,
                  controller: passwordTextController.value,
                  onChanged: (value) => passwordTextController.refresh(),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                )
              ],
            )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Get.back(),
                      child: Text("Cancel")),
                  TextButton(onPressed: () => {

                  },
                      child: Text("Create")),
                ],
              )
            ],
          )
        );
      },
    );
  }
}

class AccountRow extends StatelessWidget {
  final String accountName;
  final Function() onTap;
  const AccountRow({required this.accountName, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: MColors.cardTint(context),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
                      child: Icon(
                        Icons.person_rounded,
                        size: 32,
                      ),
                    )
                  ],
                ),
                Text(accountName, style: const TextStyle(fontSize: 24))
              ],
            ),
          ),
        ),
      ),
    );
  }

}