import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';
import 'users_result.dart';

class FakeUserRepository implements UserRepository {
  FakeUserRepository({this.fail = false, this.delay = Duration.zero});

  bool fail;
  Duration delay;

  static const List<User> _users = [
    User(
      id: 1,
      name: 'Leanne Graham',
      username: 'Bret',
      email: 'Sincere@april.biz',
      phone: '1-770-736-8031 x56442',
      website: 'hildegard.org',
      address: Address(
        street: 'Kulas Light',
        suite: 'Apt. 556',
        city: 'Gwenborough',
        zipcode: '92998-3874',
        geo: Geo(lat: -37.3159, lng: 81.1496),
      ),
    ),
    User(
      id: 2,
      name: 'Ervin Howell',
      username: 'Antonette',
      email: 'Shanna@melissa.tv',
      phone: '010-692-6593 x09125',
      website: 'anastasia.net',
      address: Address(
        street: 'Victor Plains',
        suite: 'Suite 879',
        city: 'Wisokyburgh',
        zipcode: '90566-7771',
        geo: Geo(lat: -43.9509, lng: -34.4618),
      ),
    ),
  ];

  Future<void> _simulate() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (fail) {
      throw const NoConnectionException();
    }
  }

  @override
  Future<UsersResult> getAll() async {
    await _simulate();
    return const UsersResult(items: _users);
  }

  @override
  Future<User> getById(int id) async {
    await _simulate();
    return _users.firstWhere(
      (u) => u.id == id,
      orElse: () => throw const NotFoundException(),
    );
  }

  @override
  Future<User> create(User draft) async {
    await _simulate();
    return User(
      id: 11,
      name: draft.name,
      username: draft.username,
      email: draft.email,
      phone: draft.phone,
      website: draft.website,
      address: draft.address,
    );
  }
}
