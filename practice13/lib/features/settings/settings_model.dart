import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  SettingsModel(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const String _darkKey = 'dark_mode';

  bool _dark = false;

  bool get dark => _dark;

  Future<void> load() async {
    _dark = await _prefs.getBool(_darkKey) ?? false;
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _dark = value;
    notifyListeners();
    await _prefs.setBool(_darkKey, value);
  }
}