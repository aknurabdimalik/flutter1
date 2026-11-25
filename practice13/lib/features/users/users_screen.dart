import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';
import 'widgets/offline_banner.dart';
import 'widgets/user_tile.dart';
import 'widgets/users_empty_view.dart';
import 'widgets/users_error_view.dart';
import 'widgets/users_filter_row.dart';
import 'widgets/users_header.dart';

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
      body = UsersErrorView(error: error, onRetry: model.load);
    } else if (users.isEmpty) {
      body = const UsersEmptyView();
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
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          if (model.fromCache) const OfflineBanner(),
          UsersHeader(count: model.items.length),
          UsersFilterRow(onChanged: model.setQuery),
          Expanded(child: body),
        ],
      ),
    );
  }
}
