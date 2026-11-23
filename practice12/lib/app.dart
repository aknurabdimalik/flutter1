import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice12/features/auth/auth_model.dart';
import 'package:practice12/features/auth/login_screen.dart';
import 'package:practice12/features/settings/settings_model.dart';
import 'package:practice12/features/users/users_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.watch<SettingsModel>().dark;
    final signedIn = context.watch<AuthModel>().signedIn;
    return MaterialApp(
      title: 'Users',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: signedIn ? const UsersScreen() : const LoginScreen(),
    );
  }
}
