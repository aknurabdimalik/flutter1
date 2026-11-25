import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle, size: 96),
            const SizedBox(height: 12),
            Text(auth.email ?? ''),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await auth.logout();
                navigator.pop();
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
