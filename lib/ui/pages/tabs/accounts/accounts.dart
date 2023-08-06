import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'accounts_controller.dart';

class AccountsTab extends StatelessWidget {
  final controller = Get.put(AccountsController());

  AccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Accounts");
  }

}