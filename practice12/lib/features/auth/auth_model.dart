import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practice12/core/storage/secure_store.dart';

class LoginException implements Exception {
  const LoginException(this.message);

  final String message;
}

class AuthModel extends ChangeNotifier {
  AuthModel(this._store, this._prefs, {this._token, this._email});

  final SecureStore _store;
  final SharedPreferencesAsync _prefs;
  String? _token;
  String? _email;

  bool get signedIn => _token != null;
  String? get email => _email;

  Future<void> login(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (password.length < 8) {
      throw const LoginException('Password must be at least 8 characters');
    }
    final token = 'tok_${email.hashCode}';
    await _store.saveToken(token);
    await _prefs.setString('email', email);
    _token = token;
    _email = email;
    notifyListeners();
  }

  Future<void> logout() async {
    await _store.clear();
    await _prefs.remove('email');
    _token = null;
    _email = null;
    notifyListeners();
  }
}
