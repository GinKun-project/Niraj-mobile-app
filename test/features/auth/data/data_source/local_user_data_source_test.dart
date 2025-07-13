import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());

  final box = await Hive.openBox<UserHiveModel>('testUserBox');
  final dataSource = LocalUserDataSource();

  group('LocalUserDataSource Tests', () {
    test('save and get user', () async {
      final user = UserHiveModel(username: 'niraj', email: 'niraj@example.com');

      await dataSource.saveUser(user);
      final fetched = await dataSource.getUser();

      expect(fetched?.username, 'niraj');
      expect(fetched?.email, 'niraj@example.com');
    });

    test('clear user', () async {
      await dataSource.clearUser();
      final user = await dataSource.getUser();

      expect(user?.username, '');
      expect(user?.email, '');
    });
  });

  tearDownAll(() async {
    await box.clear();
    await box.close();
  });
}
