import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'new_user_screen.dart';
import 'users_model.dart';
import 'users_views.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const NewUserScreen())),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(m),
    );
  }

  Widget _buildBody(UsersModel m) {
    if (m.loading) return const LoadingView();
    return switch (m.error) {
      null => UserList(users: m.items, onRefresh: m.load),
      NoConnectionException() => Offline(onRetry: m.load),
      NotFoundException() || UnauthorizedException() => const GenericError(
        message: 'The server refused the request.',
      ),
      ServerException(:final status) => ServerError(
        status: status,
        onRetry: m.load,
      ),
      BadResponseException() => const GenericError(),
    };
  }
}
