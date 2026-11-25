import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> _items = const [];
  bool _loading = false;
  bool _fromCache = false;
  ApiException? _error;
  String _query = '';

  List<User> get items => _items;
  bool get loading => _loading;
  bool get fromCache => _fromCache;
  ApiException? get error => _error;
  String get query => _query;

  List<User> get filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items
        .where(
          (u) =>
      u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q),
    )
        .toList();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _repo.getAll();
      _items = result.items;
      _fromCache = result.fromCache;
    } on ApiException catch (e) {
      log('load failed: $e', name: 'users');
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}