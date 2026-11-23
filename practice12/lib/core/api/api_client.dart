import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:practice12/core/api/app_exceptions.dart';
import 'package:practice12/core/storage/secure_store.dart';

class ApiClient {
  ApiClient(this._client, this._store);

  final http.Client _client;
  final SecureStore _store;

  static const _base = 'https://jsonplaceholder.typicode.com';

  Future<Map<String, String>> _headers() async => {
    'Accept': 'application/json',
    if (await _store.readToken() case final t?) 'Authorization': 'Bearer $t',
  };

  Future<List<dynamic>> getList(String path) async {
    final http.Response response;
    try {
      response = await _client
          .get(Uri.parse('$_base$path'), headers: await _headers())
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }

    if (response.statusCode != 200) {
      throw ServerException(response.statusCode);
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const BadDataException();
    }
    if (decoded is! List<dynamic>) {
      throw const BadDataException();
    }
    return decoded;
  }
}
