import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),
          ListTile(title: const Text('Email'), subtitle: Text(user.email)),
          ListTile(title: const Text('Phone'), subtitle: Text(user.phone)),
          ListTile(title: const Text('Website'), subtitle: Text(user.website)),
          ListTile(
            title: const Text('Address'),
            subtitle: Text(
              '${user.address.street}, ${user.address.suite}, '
              '${user.address.city}, ${user.address.zipcode}',
            ),
          ),
          ListTile(
            title: const Text('Geo'),
            subtitle: Text('${user.address.geo.lat}, ${user.address.geo.lng}'),
          ),
        ],
      ),
    );
  }
}
