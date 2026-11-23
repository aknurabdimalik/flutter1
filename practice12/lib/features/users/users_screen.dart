import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice12/core/api/app_exceptions.dart';
import 'package:practice12/features/profile/profile_screen.dart';
import 'package:practice12/features/settings/settings_model.dart';
import 'package:practice12/features/settings/settings_screen.dart';
import 'package:practice12/features/users/user.dart';
import 'package:practice12/features/users/user_detail_screen.dart';
import 'package:practice12/features/users/users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();
    final city = context.watch<SettingsModel>().city;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: _body(model, city),
    );
  }

  Widget _body(UsersModel model, String? city) {
    if (model.users.isEmpty) {
      if (model.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      final error = model.error;
      if (error != null) {
        return _ErrorView(error: error, onRetry: model.load);
      }
      return const Center(child: Text('No users'));
    }
    final visible = [
      for (final u in model.users)
        if (city == null || u.city == city) u,
    ];
    return Column(
      children: [
        if (model.loading) const LinearProgressIndicator(),
        if (model.fromCache)
          MaterialBanner(
            leading: const Icon(Icons.cloud_off),
            content: const Text('Saved data · no connection'),
            actions: [
              TextButton(onPressed: model.load, child: const Text('Retry')),
            ],
          ),
        Expanded(
          child: visible.isEmpty
              ? Center(child: Text('No users in $city'))
              : ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (context, index) =>
                      _UserTile(user: visible[index]),
                ),
        ),
      ],
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(user.name[0])),
      title: Text(user.name),
      subtitle: Text('${user.city} · ${user.email}'),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => UserDetailScreen(user: user)),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final AppException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final offline = error is NoConnectionException;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(offline ? Icons.wifi_off : Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              offline ? 'Offline' : 'Server problem',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              offline
                  ? 'Check your connection and try again.'
                  : 'Something went wrong on the server.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
