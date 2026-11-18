import 'package:flutter/material.dart';

import 'user.dart';
import 'user_detail_screen.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

class Offline extends StatelessWidget {
  const Offline({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _ErrorBody(
      icon: Icons.wifi_off,
      title: 'No connection',
      message: 'Check your internet and try again.',
      onRetry: onRetry,
    );
  }
}

class ServerError extends StatelessWidget {
  const ServerError({super.key, required this.status, required this.onRetry});

  final int status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _ErrorBody(
      icon: Icons.cloud_off,
      title: 'Server error ($status)',
      message: 'The server has a problem. Try again later.',
      onRetry: onRetry,
    );
  }
}

class GenericError extends StatelessWidget {
  const GenericError({
    super.key,
    this.message = 'We could not read the data from the server.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return _ErrorBody(
      icon: Icons.error_outline,
      title: 'Something went wrong',
      message: message,
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key, required this.users, required this.onRefresh});

  final List<User> users;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text('${user.email}\n${user.address.city}'),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => UserDetailScreen(user: user),
              ),
            ),
          );
        },
      ),
    );
  }
}
