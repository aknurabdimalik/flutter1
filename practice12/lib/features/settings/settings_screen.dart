import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice12/features/auth/auth_model.dart';
import 'package:practice12/features/settings/settings_model.dart';
import 'package:practice12/features/users/users_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final cities = context.watch<UsersModel>().cities;
    final city = settings.city;
    final options = {...cities, ?city}.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: settings.dark,
            onChanged: settings.setDark,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String?>(
              initialValue: city,
              decoration: const InputDecoration(labelText: 'City filter'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All cities'),
                ),
                for (final c in options)
                  DropdownMenuItem<String?>(value: c, child: Text(c)),
              ],
              onChanged: settings.setCity,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              final navigator = Navigator.of(context);
              await context.read<AuthModel>().logout();
              navigator.popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
