import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String email;

  UserHiveModel({required this.username, required this.email});
}
