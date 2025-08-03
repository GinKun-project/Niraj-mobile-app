import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/core/services/hive_service.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_repository_impl.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/login_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/signup_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shadow_clash_frontend/features/game/data/repository/game_repository_impl.dart';
import 'package:shadow_clash_frontend/features/game/domain/repository/game_repository.dart';

final GetIt getIt = GetIt.instance;

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigator => navigatorKey.currentState!;

  void navigateTo(String routeName) {
    navigator.pushNamed(routeName);
  }

  void navigateToReplacement(String routeName) {
    navigator.pushReplacementNamed(routeName);
  }

  void navigateToAndClear(String routeName) {
    navigator.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  void goBack() {
    navigator.pop();
  }
}

Future<void> setupServiceLocator() async {
  await HiveService.initializeHive();

  getIt.registerLazySingleton<NavigationService>(() => NavigationService());

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );
  getIt.registerLazySingleton<LocalUserDataSource>(() => LocalUserDataSource());

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<GameRepository>(() => GameRepositoryImpl());

  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<SignupUseCase>(() => SignupUseCase(getIt()));

  getIt.registerFactory(() => LoginViewModel(getIt()));
  getIt.registerFactory(() => SignupViewModel(getIt()));
  getIt.registerFactory(() => SplashViewModel());
  getIt.registerFactory(() => DashboardViewModel());
}
