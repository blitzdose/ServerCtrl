import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'accounts_controller.dart';

class AccountsTab extends StatelessWidget {
  final controller = Get.put(AccountsController());

  final ScrollController scrollController = ScrollController();

  AccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Column(
          children: [
            if (controller.showProgress.value) const LinearProgressIndicator(),
            Expanded(
              child: SizedBox(
                width: min(700, MediaQuery.of(context).size.width),
                child: Scrollbar(
                  controller: scrollController,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    children: controller.accountItems,
                  ),
                ),
              ),
            )
          ],
        )
    );
  }

}