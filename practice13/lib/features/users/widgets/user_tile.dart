import 'package:flutter/material.dart';

import '../user.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user, required this.onTap});

  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.name.isEmpty ? '?' : user.name[0]),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
