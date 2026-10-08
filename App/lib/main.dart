import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:server_ctrl/navigator_key.dart';
import 'package:server_ctrl/ui/views/add_client/add_client.dart';
import 'package:server_ctrl/ui/views/add_client/add_client_controller.dart';
import 'package:server_ctrl/ui/views/add_server/add_server.dart';
import 'package:server_ctrl/ui/views/add_server/add_server_controller.dart';
import 'package:server_ctrl/ui/views/app_settings/app_settings.dart';
import 'package:server_ctrl/ui/views/app_settings/app_settings_controller.dart';
import 'package:server_ctrl/ui/views/main_view/main_controller.dart';
import 'package:server_ctrl/ui/views/main_view/main_view.dart';
import 'package:server_ctrl/ui/views/splash_screen/splash_screen.dart';
import 'package:server_ctrl/ui/views/splash_screen/splash_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';
import 'main_controller.dart';
import 'package:get/get.dart';

import 'dart:io';

SharedPreferences? prefs;

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      String hash = hex.encode(cert.sha1).toUpperCase();
      hash = RegExp(r".{2}")
        .allMatches(hash)
        .map((e) => e.group(0))
        .join(":");

        List<String>? acceptedCerts = prefs?.getStringList("accepted_certs");
        if (acceptedCerts != null && acceptedCerts.contains(hash)) {
          return true;
        } else {
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(S.current.untrustedCertificate),
                content: SizedBox(
                  width: min(400, MediaQuery.of(context).size.width),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(S.current.certCannotBeVerified),
                      const Padding(padding: EdgeInsets.only(top: 8.0)),
                      Text(hash)
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text(S.current.no)),
                  TextButton(onPressed: () async {
                    acceptedCerts ??= [];
                    acceptedCerts?.add(hash);
                    await prefs?.setStringList("accepted_certs", acceptedCerts!);
                    Navigator.pop(navigatorKey.currentContext!, true);
                  }, child: Text(S.current.yes)),
                ],
              );
            },
          );
        }

        return false;
      };
  }
}

Future<void> main() async {
  debugPaintSizeEnabled = false;
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
  prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {

  final controller = Get.put(MyAppController());
  MyApp({super.key}) {
    //controller.init();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    Widget widget = DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return Obx(() => GetMaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          LocaleNamesLocalizationsDelegate(),
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: MyAppController.appName.value,
        theme: buildTheme(
            brightness: Brightness.light,
            dynamicScheme: MyAppController.usesDynamicColor.isTrue ? lightDynamic : null,
            material3: true,
            seedColor: MyAppController.mainColor.value),
        darkTheme: buildTheme(
            brightness: Brightness.dark,
            dynamicScheme: MyAppController.usesDynamicColor.isTrue ? darkDynamic: null,
            material3: true,
            seedColor: MyAppController.mainColor.value),
        themeMode: MyAppController.themeMode.value,
        locale: MyAppController.locale.value,
        initialRoute: SplashScreenView.route,
        initialBinding: SplashScreenBinding(),
        getPages: [
          GetPage(
              name: SplashScreenView.route,
              page: () => SplashScreenView(),
              binding: SplashScreenBinding()
          ),
          GetPage(
              name: AddServerView.route,
              page: () => AddServerView(),
              binding: AddServerBinding()
          ),
          GetPage(
              name: AddClientView.route,
              page: () => AddClientView(),
              binding: AddClientBinding()
          ),
          GetPage(
              name: MainView.route,
              page: () => MainView(),
              binding: MainBinding()
          ),
          GetPage(
              name: AppSettingsView.route,
              page: () => AppSettingsView(),
              binding: AppSettingsBinding()
          )
        ],
        navigatorKey: navigatorKey,
      ));
    });
    controller.init();
    return widget;
  }

  ThemeData buildTheme({
    required Brightness brightness,
    ColorScheme? dynamicScheme,
    required bool material3,
    required Color seedColor,
  }) {
    ColorScheme colorScheme;
    if (dynamicScheme != null) {
      colorScheme = ColorScheme.fromSeed(
        seedColor: dynamicScheme.primary,
        brightness: brightness,
      );
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      );
    }
    return ThemeData.from(
      colorScheme: colorScheme.harmonized(),
      useMaterial3: material3,
    ).copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating, // Floating floating card (M3 standard)
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        checkmarkColor: colorScheme.onSurfaceVariant,
        deleteIconColor: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
