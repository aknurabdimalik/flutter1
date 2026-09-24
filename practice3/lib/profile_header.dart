import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  final String name;
  final String university;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Image.asset(
          'assets/images/me.png',
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            name,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 24,
              color: scheme.primary,
            ),
          ),
        ),
        Text(university, style: TextStyle(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}
