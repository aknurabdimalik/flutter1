import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_cache.dart';
import 'users_result.dart';

abstract interface class UserRepository {
  Future<UsersResult> getAll();
  Future<User> getById(int id);
  Future<User> create(User draft);
}

class HttpUserRepository implements UserRepository {
  HttpUserRepository(this._api, [this._cache]);

  final ApiClient _api;
  final UsersCache? _cache;

  @override
  Future<UsersResult> getAll() async {
    try {
      final json = await _api.get('/users');
      final users = _parse(
            () => (json as List<dynamic>)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      await _cache?.save(users);
      return UsersResult(items: users);
    } on NoConnectionException {
      final cached = await _cache?.load();
      if (cached == null) rethrow;
      return UsersResult(items: cached, fromCache: true);
    }
  }

  @override
  Future<User> getById(int id) async {
    final json = await _api.get('/users/$id');
    return _parse(() => User.fromJson(json as Map<String, dynamic>));
  }

  @override
  Future<User> create(User draft) async {
    final json = await _api.post('/users', draft.toJson());
    return _parse(() => User.fromJson(json as Map<String, dynamic>));
  }

  T _parse<T>(T Function() build) {
    try {
      return build();
    } on TypeError catch (e) {
      throw BadResponseException('users: unexpected field type ($e)');
    }
  }
}