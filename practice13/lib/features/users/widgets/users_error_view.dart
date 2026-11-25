import 'package:flutter/material.dart';

import '../../../core/api/api_exception.dart';

class UsersErrorView extends StatelessWidget {
  const UsersErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final ApiException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = switch (error) {
      NoConnectionException() => 'No connection',
      NotFoundException() => 'Not found',
      ServerException() => 'Server is having trouble',
      BadResponseException() => 'Something went wrong',
    };
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 64),
          const SizedBox(height: 12),
          Text(text, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}