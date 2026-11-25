import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practice13/core/api/api_client.dart';
import 'package:practice13/core/api/api_exception.dart';
import 'package:practice13/features/users/user_repository.dart';

import '../../fakes/sample_json.dart';

UserRepository repoWith(MockClientHandler handler) {
  return HttpUserRepository(ApiClient(MockClient(handler)));
}

void main() {
  group('HttpUserRepository error mapping', () {
    test('404 -> NotFoundException', () {
      final repo = repoWith(
        (_) async => http.Response('{"error":"gone"}', 404),
      );

      expect(repo.getById(99), throwsA(isA<NotFoundException>()));
    });

    test('500 -> ServerException', () {
      final repo = repoWith((_) async => http.Response('oops', 500));

      expect(repo.getById(1), throwsA(isA<ServerException>()));
    });

    test('SocketException -> NoConnectionException', () {
      final repo = repoWith((_) async => throw const SocketException('down'));

      expect(repo.getById(1), throwsA(isA<NoConnectionException>()));
    });
  });

  group('HttpUserRepository parsing', () {
    test('getAll parses a valid list', () async {
      final body = jsonEncode([sampleUserJson()]);
      final repo = repoWith((_) async => http.Response(body, 200));

      final result = await repo.getAll();

      expect(result.items.length, 1);
      expect(result.fromCache, isFalse);
    });

    test('lat as a number -> BadResponseException', () {
      final body = jsonEncode([sampleUserJson(lat: -37.3159)]);
      final repo = repoWith((_) async => http.Response(body, 200));

      expect(repo.getAll(), throwsA(isA<BadResponseException>()));
    });
  });
}
