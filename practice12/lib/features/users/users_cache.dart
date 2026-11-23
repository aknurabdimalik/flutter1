import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:practice12/features/users/user.dart';

class UsersCache {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  Future<void> save(List<User> users) async {
    final file = await _file();
    await file.writeAsString(jsonEncode([for (final u in users) u.toJson()]));
  }

  Future<List<User>?> load() async {
    final file = await _file();
    if (!await file.exists()) return null;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! List<dynamic>) return null;
      return [
        for (final item in decoded) User.fromJson(item as Map<String, dynamic>),
      ];
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
