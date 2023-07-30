import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'ui/navigation/layout_structure.dart';
import 'values/colors.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return GetMaterialApp(
        title: 'ServerCtrl',
        theme: ThemeData(
          colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: MColors.seed),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic ?? ColorScheme.fromSeed(seedColor: MColors.seed, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const LayoutStructure(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      );
    });
  }
}
