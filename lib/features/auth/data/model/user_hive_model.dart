import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? token; // NEW FIELD

  UserHiveModel({
    required this.username,
    required this.email,
    this.token, // Optional for signup
  });
}
