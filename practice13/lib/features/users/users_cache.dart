import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'user.dart';

class UsersCache {
  UsersCache(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const String _key = 'users_cache';

  Future<void> save(List<User> users) {
    final raw = jsonEncode(users.map((u) => u.toJson()).toList());
    return _prefs.setString(_key, raw);
  }

  Future<List<User>?> load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object {
      return null;
    }
  }
}