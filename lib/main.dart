import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minecraft_server_remote/navigator_key.dart';
import 'generated/l10n.dart';
import 'ui/navigation/layout_structure.dart';
import 'values/colors.dart';
import 'package:get/get.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return GetMaterialApp(
        title: 'ServerCtrl',
        theme: buildTheme(brightness: Brightness.light, dynamicScheme: lightDynamic),
        darkTheme: buildTheme(brightness: Brightness.dark, dynamicScheme: darkDynamic),
        home: const LayoutStructure(),
        navigatorKey: navigatorKey,
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

  ThemeData buildTheme({
    required Brightness brightness,
    ColorScheme? dynamicScheme,
  }) {
    final classicScheme = ColorScheme.fromSeed(
      seedColor: MColors.seed,
      brightness: brightness,
    );
    late ColorScheme colorScheme = dynamicScheme ?? classicScheme;
    return ThemeData.from(
      colorScheme: colorScheme.harmonized(),
      useMaterial3: true,
    ).copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        checkmarkColor: colorScheme.onSurfaceVariant,
        deleteIconColor: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
