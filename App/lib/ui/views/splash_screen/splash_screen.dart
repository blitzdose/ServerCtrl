import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import 'splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {

  static final String route = "/splash";

  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator()
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 128),
              child: Text(S.current.loading, style: Theme.of(context).textTheme.headlineLarge,),
            ),
          )
        ],
      )
    );
  }

}