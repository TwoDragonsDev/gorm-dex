import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Use dynamic colors if available (Android 12+), otherwise use seed-based
        final colorScheme = darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: AppTheme.seedColor,
              brightness: Brightness.dark,
            );

        final theme = AppTheme.buildDarkTheme(colorScheme);

        return MaterialApp.router(
          title: 'Gorm Wiki',
          debugShowCheckedModeBanner: false,
          theme: theme,
          routerConfig: router,
        );
      },
    );
  }
}
