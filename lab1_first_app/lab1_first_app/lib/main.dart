import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeModeScope(
      mode: _themeMode,
      onChanged: _setThemeMode,
      child: MaterialApp(
        title: 'Campus Events',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: _themeMode,
        routes: {Routes.shell: (context) => const HomeShell()},
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
      ),
    );
  }
}
