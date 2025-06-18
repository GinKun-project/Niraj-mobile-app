import 'package:shadow_clash_frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> login(String email, String password) async {
    try {
      // Replace this with real logic if API is added
      await remoteDataSource.login(email, password);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> signup(String username, String email, String password) async {
    try {
      // Replace this with real logic if API is added
      await remoteDataSource.signup(username, email, password);
      return true;
    } catch (_) {
      return false;
    }
  }
}
