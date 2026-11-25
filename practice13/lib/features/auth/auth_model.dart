import 'package:flutter/foundation.dart';

import '../../core/storage/secure_store.dart';

class AuthModel extends ChangeNotifier {
  AuthModel(this._store);

  final SecureStore _store;

  static const String _key = 'session_email';

  bool _ready = false;
  String? _email;

  bool get ready => _ready;
  bool get loggedIn => _email != null;
  String? get email => _email;

  Future<void> restore() async {
    _email = await _store.read(_key);
    _ready = true;
    notifyListeners();
  }

  Future<void> login(String email) async {
    await _store.write(_key, email);
    _email = email;
    notifyListeners();
  }

  Future<void> logout() async {
    await _store.delete(_key);
    _email = null;
    notifyListeners();
  }
}