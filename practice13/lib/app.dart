import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_gate.dart';
import 'features/settings/settings_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.select((SettingsModel s) => s.dark);
    return MaterialApp(
      title: 'Users',
      debugShowCheckedModeBanner: false,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const AuthGate(),
    );
  }
}
