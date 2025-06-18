import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';

class HiveService {
  static Future<void> initializeHive() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);

    // Register all Hive adapters here
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  static Future<void> closeHive() async {
    await Hive.close();
  }
}
