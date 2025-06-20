import 'package:shadow_clash_frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/login_response.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginResponse?> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<LoginResponse?> signup(
    String username,
    String email,
    String password,
  ) {
    return remoteDataSource.signup(username, email, password);
  }
}
