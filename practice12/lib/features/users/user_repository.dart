import 'package:practice12/core/api/api_client.dart';
import 'package:practice12/core/api/app_exceptions.dart';
import 'package:practice12/features/users/user.dart';
import 'package:practice12/features/users/users_cache.dart';

typedef UsersResult = ({List<User> items, bool fromCache});

class UserRepository {
  UserRepository(this._api, this._cache);

  final ApiClient _api;
  final UsersCache _cache;

  Future<UsersResult> getAll() async {
    try {
      final fresh = await _fetch();
      await _cache.save(fresh);
      return (items: fresh, fromCache: false);
    } on NoConnectionException {
      final saved = await _cache.load();
      if (saved == null) rethrow;
      return (items: saved, fromCache: true);
    }
  }

  Future<List<User>> _fetch() async {
    final raw = await _api.getList('/users');
    try {
      return [
        for (final item in raw) User.fromJson(item as Map<String, dynamic>),
      ];
    } on TypeError {
      throw const BadDataException();
    }
  }
}
