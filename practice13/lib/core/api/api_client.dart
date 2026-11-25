import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;

  static const String host = 'jsonplaceholder.typicode.com';

  Future<dynamic> get(String path) async {
    final response = await _send(() => _client.get(Uri.https(host, path)));
    return _decode(_check(response));
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await _send(
          () => _client.post(
        Uri.https(host, path),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      ),
    );
    return _decode(_check(response));
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    }
  }

  http.Response _check(http.Response response) {
    final code = response.statusCode;
    log('HTTP $code', name: 'api');
    if (code >= 200 && code < 300) return response;
    if (code == 404) throw const NotFoundException();
    if (code >= 500) throw ServerException(code);
    throw BadResponseException('Unexpected status $code');
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const BadResponseException('Body is not JSON');
    }
  }
}