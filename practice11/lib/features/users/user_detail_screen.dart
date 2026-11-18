import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final address = user.address;
    final website = user.website;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.username),
            subtitle: const Text('username'),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(user.email),
            subtitle: const Text('email'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.phone),
            subtitle: Text('digits: ${user.phoneDigits}'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(website ?? 'no website'),
            subtitle: const Text('website'),
            onTap: website == null ? null : () {},
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('${address.street}, ${address.suite}'),
            subtitle: Text('${address.city}, ${address.zipcode}'),
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: Text('${address.geo.lat}, ${address.geo.lng}'),
            subtitle: const Text('geo'),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: Text(user.company.name),
            subtitle: Text(user.company.catchPhrase),
          ),
        ],
      ),
    );
  }
}
