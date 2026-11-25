import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:practice13/features/users/user.dart';

const String userOneJson = '''
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {"lat": "-37.3159", "lng": "81.1496"}
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org"
}
''';

void main() {
  group('User.fromJson', () {
    test('parses user 1: name, city and lat as double', () {
      final json = jsonDecode(userOneJson) as Map<String, dynamic>;

      final user = User.fromJson(json);

      expect(user.name, 'Leanne Graham');
      expect(user.address.city, 'Gwenborough');
      expect(user.address.geo.lat, -37.3159);
      expect(user.address.geo.lat, isA<double>());
    });

    test('id as a String throws TypeError', () {
      final json = jsonDecode(userOneJson) as Map<String, dynamic>;
      json['id'] = '1';

      expect(() => User.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('Geo.fromJson', () {
    test('lat as a number (planted bug) throws TypeError', () {
      final json = <String, dynamic>{'lat': -37.3159, 'lng': '81.1496'};

      expect(() => Geo.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}