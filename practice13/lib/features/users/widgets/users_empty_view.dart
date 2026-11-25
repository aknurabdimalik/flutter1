import 'package:flutter/material.dart';

class UsersEmptyView extends StatelessWidget {
  const UsersEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No users found'));
  }
}