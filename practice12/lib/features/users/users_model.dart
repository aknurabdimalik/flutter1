import 'package:flutter/foundation.dart';
import 'package:practice12/core/api/app_exceptions.dart';
import 'package:practice12/features/users/user.dart';
import 'package:practice12/features/users/user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> _users = const [];
  bool _loading = true;
  bool _fromCache = false;
  AppException? _error;

  List<User> get users => _users;
  bool get loading => _loading;
  bool get fromCache => _fromCache;
  AppException? get error => _error;

  List<String> get cities =>
      ({for (final u in _users) u.city}.toList()..sort());

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _repo.getAll();
      _users = result.items;
      _fromCache = result.fromCache;
    } on AppException catch (e) {
      _error = e;
    }
    _loading = false;
    notifyListeners();
  }
}
