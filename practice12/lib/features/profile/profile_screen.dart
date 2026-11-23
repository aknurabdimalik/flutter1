import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:practice12/features/auth/auth_model.dart';
import 'package:practice12/features/profile/profile_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _choose(BuildContext context) async {
    final model = context.read<ProfileModel>();
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;
    await model.savePhoto(picked.path);
  }

  Future<void> _take(BuildContext context) async {
    final model = context.read<ProfileModel>();
    final status = await Permission.camera.request();
    if (!context.mounted) return;
    switch (status) {
      case PermissionStatus.granted ||
          PermissionStatus.limited ||
          PermissionStatus.provisional:
        final picked = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 1024,
          imageQuality: 85,
        );
        if (picked == null) return;
        await model.savePhoto(picked.path);
      case PermissionStatus.denied:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The camera is needed to take a photo. '
              'You can still choose one from the gallery.',
            ),
          ),
        );
      case PermissionStatus.restricted:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The camera is restricted on this device.'),
          ),
        );
      case PermissionStatus.permanentlyDenied:
        await _showSettingsDialog(context);
    }
  }

  Future<void> _showSettingsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Camera is blocked'),
        content: const Text(
          'The system will not ask again. Open settings and allow the '
          'camera, or choose a photo from the gallery.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await openAppSettings();
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = context.watch<ProfileModel>().avatarPath;
    final email = context.watch<AuthModel>().email;
    final initial = (email != null && email.isNotEmpty)
        ? email[0].toUpperCase()
        : '?';
    final file = path == null ? null : File(path);
    final ImageProvider? image = (file != null && file.existsSync())
        ? FileImage(file)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundImage: image,
              child: image == null
                  ? Text(initial, style: const TextStyle(fontSize: 48))
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _choose(context),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Choose photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _take(context),
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Take photo'),
            ),
          ],
        ),
      ),
    );
  }
}
