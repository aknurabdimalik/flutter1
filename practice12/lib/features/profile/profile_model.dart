import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel extends ChangeNotifier {
  ProfileModel(this._prefs, {this._avatarPath});

  final SharedPreferencesAsync _prefs;
  String? _avatarPath;

  String? get avatarPath => _avatarPath;

  Future<void> savePhoto(String pickedPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final target = File('${dir.path}/avatar.jpg');
    await File(pickedPath).copy(target.path);
    await FileImage(target).evict();
    _avatarPath = target.path;
    notifyListeners();
    await _prefs.setString('avatarPath', target.path);
  }
}
