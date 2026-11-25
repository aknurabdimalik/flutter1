import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/api/api_client.dart';
import 'core/storage/secure_store.dart';
import 'features/auth/auth_model.dart';
import 'features/settings/settings_model.dart';
// ignore: unused_import
import 'features/users/fake_user_repository.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_cache.dart';
import 'features/users/users_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = SharedPreferencesAsync();
  final api = ApiClient();

  final UserRepository repo = HttpUserRepository(api, UsersCache(prefs));
  // final UserRepository repo = FakeUserRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersModel(repo)..load()),
        ChangeNotifierProvider(
          create: (_) => AuthModel(SecureStore())..restore(),
        ),
        ChangeNotifierProvider(create: (_) => SettingsModel(prefs)..load()),
      ],
      child: const MyApp(),
    ),
  );
}
