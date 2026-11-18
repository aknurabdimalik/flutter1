import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
    final http.Response response = await _api.get(
      Uri.https(_api.host, '/users'),
    );
    final body = _api.decode(response);
    return _parse('users', () {
      final list = body as List<dynamic>;
      return [
        for (final item in list) User.fromJson(item as Map<String, dynamic>),
      ];
    });
  }

  Future<User> getById(int id) async {
    final http.Response response = await _api.get(
      Uri.https(_api.host, '/users/$id'),
    );
    final body = _api.decode(response);
    return _parse(
      'users/$id',
      () => User.fromJson(body as Map<String, dynamic>),
    );
  }

  Future<User> create(User draft) async {
    final json = draft.toJson()..remove('id');
    final http.Response response = await _api.post(
      Uri.https(_api.host, '/users'),
      body: jsonEncode(json),
    );
    if (response.statusCode != 201) {
      throw BadResponseException(
        'users (create): expected 201, got ${response.statusCode}',
      );
    }
    final body = _api.decode(response);
    return _parse(
      'users (create)',
      () => User.fromJson(body as Map<String, dynamic>),
    );
  }

  /// Runs [build]; a failed cast or a bad number becomes BadResponseException.
  T _parse<T>(String where, T Function() build) {
    try {
      return build();
    } on TypeError catch (e) {
      throw BadResponseException('$where: $e');
    } on FormatException catch (e) {
      throw BadResponseException('$where: $e');
    }
  }
}
