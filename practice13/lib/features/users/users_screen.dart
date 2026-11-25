import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';
import 'widgets/offline_banner.dart';
import 'widgets/user_tile.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();
    final error = model.error;
    final users = model.filtered;

    final Widget body;
    if (model.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      final text = switch (error) {
        NoConnectionException() => 'No connection',
        NotFoundException() => 'Not found',
        ServerException() => 'Server is having trouble',
        BadResponseException() => 'Something went wrong',
      };
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 64),
            const SizedBox(height: 12),
            Text(text, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            FilledButton(onPressed: model.load, child: const Text('Retry')),
          ],
        ),
      );
    } else if (users.isEmpty) {
      body = const Center(child: Text('No users found'));
    } else {
      body = ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserTile(
            user: user,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (model.fromCache) const OfflineBanner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total users: ${model.items.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: model.setQuery,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name or email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}