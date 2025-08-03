import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';

void main() {
  group('LocalUserDataSource Tests', () {
    late LocalUserDataSource dataSource;
    late Box<UserHiveModel> box;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();
      Hive.registerAdapter(UserHiveModelAdapter());
    });

    setUp(() async {
      box = await Hive.openBox<UserHiveModel>('testUserBox');
      dataSource = LocalUserDataSource();
    });

    tearDown(() async {
      await box.clear();
      await box.close();
    });

    test('save and get user', () async {
      final user = UserHiveModel(username: 'niraj', email: 'niraj@example.com');

      await dataSource.saveUser(user);
      final fetched = await dataSource.getUser();

      expect(fetched?.username, 'niraj');
      expect(fetched?.email, 'niraj@example.com');
    });

    test('clear user', () async {
      final user = UserHiveModel(username: 'niraj', email: 'niraj@example.com');
      await dataSource.saveUser(user);

      await dataSource.clearUser();
      final fetched = await dataSource.getUser();

      expect(fetched, isNull);
    });

    test('isUserLoggedIn returns true when user exists', () async {
      final user = UserHiveModel(username: 'niraj', email: 'niraj@example.com');
      await dataSource.saveUser(user);

      final isLoggedIn = await dataSource.isUserLoggedIn();
      expect(isLoggedIn, isTrue);
    });

    test('isUserLoggedIn returns false when no user exists', () async {
      final isLoggedIn = await dataSource.isUserLoggedIn();
      expect(isLoggedIn, isFalse);
    });
  });
}
