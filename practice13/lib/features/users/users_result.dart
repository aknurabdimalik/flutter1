import 'user.dart';

class UsersResult {
  const UsersResult({required this.items, this.fromCache = false});

  final List<User> items;
  final bool fromCache;
}
