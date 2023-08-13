import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'accounts_controller.dart';

class AccountsTab extends StatelessWidget {
  final controller = Get.put(AccountsController());

  AccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Column(
          children: [
            if (controller.showProgress.value) const LinearProgressIndicator(),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: controller.accountItems,
                ),
              ),
            )
          ],
        )
    );
  }

}