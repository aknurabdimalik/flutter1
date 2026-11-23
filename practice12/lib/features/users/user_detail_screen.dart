import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:practice12/core/storage/secure_store.dart';
import 'package:practice12/features/users/user.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  Future<void> _open(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No app can open this')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          _InfoTile(
            icon: Icons.person_outline,
            label: 'Username',
            value: user.username,
          ),
          _InfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email,
            onTap: () =>
                _open(context, Uri(scheme: 'mailto', path: user.email)),
          ),
          _InfoTile(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: user.phone,
            onTap: () =>
                _open(context, Uri(scheme: 'tel', path: user.phoneDigits)),
          ),
          _InfoTile(
            icon: Icons.language,
            label: 'Website',
            value: user.website,
            onTap: () => _open(context, Uri.parse('https://${user.website}')),
          ),
          _InfoTile(icon: Icons.location_city, label: 'City', value: user.city),
          _InfoTile(
            icon: Icons.business,
            label: 'Company',
            value: user.company,
          ),
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copy token to clipboard'),
                onPressed: () async {
                  final store = context.read<SecureStore>();
                  final messenger = ScaffoldMessenger.of(context);
                  final token = await store.readToken();
                  if (token == null) return;
                  await Clipboard.setData(ClipboardData(text: token));
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Token copied')),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(value),
      subtitle: Text(label),
      onTap: onTap,
      trailing: onTap == null ? null : const Icon(Icons.open_in_new, size: 18),
    );
  }
}
