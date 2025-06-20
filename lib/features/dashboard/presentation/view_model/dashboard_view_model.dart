import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';

class DashboardViewModel extends ChangeNotifier {
  final LocalUserDataSource _dataSource = LocalUserDataSource();

  UserHiveModel? _user;
  UserHiveModel? get user => _user;

  Future<void> loadUser() async {
    _user = await _dataSource.getUser();
    notifyListeners();
  }
}
