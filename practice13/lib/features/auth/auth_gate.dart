import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../users/users_screen.dart';
import 'auth_model.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthModel>();
    if (!auth.ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.loggedIn ? const UsersScreen() : const LoginScreen();
  }
}
