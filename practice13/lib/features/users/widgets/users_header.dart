import 'package:flutter/material.dart';

class UsersHeader extends StatelessWidget {
  const UsersHeader({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Total users: $count',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
