import 'package:get_it/get_it.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRemoteDataSource());

  // ViewModels
  getIt.registerFactory(() => LoginViewModel(getIt()));
  getIt.registerFactory(() => SignupViewModel(getIt()));
}
