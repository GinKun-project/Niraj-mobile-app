import 'package:get_it/get_it.dart';
import 'package:shadow_clash_frontend/core/services/hive_service.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_repository_impl.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view_model/splash_view_model.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ✅ Initialize Hive
  await HiveService.initializeHive();

  // ✅ Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );
  getIt.registerLazySingleton<LocalUserDataSource>(() => LocalUserDataSource());

  // ✅ Repository Implementation
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // ✅ ViewModels
  getIt.registerFactory(() => LoginViewModel(getIt()));
  getIt.registerFactory(() => SignupViewModel(getIt()));
  getIt.registerFactory(() => SplashViewModel());
}
