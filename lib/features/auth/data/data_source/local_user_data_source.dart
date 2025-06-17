import 'package:hive/hive.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';

class LocalUserDataSource {
  static const String _boxName = 'user_box';
  static const String _key = 'currentUser';

  /// Save the logged-in user to Hive
  Future<void> saveUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(_boxName);
    await box.put(_key, user);
  }

  /// Retrieve the currently logged-in user
  Future<UserHiveModel?> getUser() async {
    final box = await Hive.openBox<UserHiveModel>(_boxName);
    return box.get(_key);
  }

  /// Clear the saved user (logout)
  Future<void> clearUser() async {
    final box = await Hive.openBox<UserHiveModel>(_boxName);
    await box.delete(_key);
  }

  /// Check if a user is already logged in
  Future<bool> isUserLoggedIn() async {
    final box = await Hive.openBox<UserHiveModel>(_boxName);
    return box.containsKey(_key);
  }
}
