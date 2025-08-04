import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/core/services/hive_service.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_repository_impl.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/login_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/signup_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';
import 'package:shadow_clash_frontend/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:shadow_clash_frontend/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:shadow_clash_frontend/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/usecase/get_dashboard_data_usecase.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/usecase/show_game_end_notification_usecase.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:shadow_clash_frontend/features/game/data/repository/game_repository_impl.dart';
import 'package:shadow_clash_frontend/features/game/data/service/audio_service.dart';
import 'package:shadow_clash_frontend/features/game/domain/repository/game_repository.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view_model/splash_view_model.dart';

final GetIt getIt = GetIt.instance;

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigator => navigatorKey.currentState!;

  void navigateTo(String routeName) {
    navigator.pushNamed(routeName);
  }

  void navigateToAndClear(String routeName) {
    navigator.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  void navigateToReplacement(String routeName) {
    navigator.pushReplacementNamed(routeName);
  }

  void goBack() {
    navigator.pop();
  }
}

Future<void> setupServiceLocator() async {
  await HiveService.initializeHive();

  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<AudioService>(() => AudioService());

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );

  getIt.registerLazySingleton<LocalUserDataSource>(() => LocalUserDataSource());

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      localDataSource: getIt<DashboardLocalDataSource>(),
      remoteDataSource: getIt<DashboardRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GameRepository>(() => GameRepositoryImpl());
  getIt.registerLazySingleton<GameRepositoryImpl>(() => GameRepositoryImpl());

  getIt.registerLazySingleton<GetDashboardDataUseCase>(
    () => GetDashboardDataUseCase(getIt<DashboardRepository>()),
  );

  getIt.registerLazySingleton<ShowGameEndNotificationUseCase>(
    () => ShowGameEndNotificationUseCase(getIt<DashboardRepository>()),
  );

  getIt.registerFactory(() => LoginViewModel(getIt<LoginUseCase>()));
  getIt.registerFactory(() => SignupViewModel(getIt<SignupUseCase>()));
  getIt.registerFactory(() => SplashViewModel());
  getIt.registerFactory(() => DashboardViewModel(
        getDashboardDataUseCase: getIt<GetDashboardDataUseCase>(),
        showGameEndNotificationUseCase: getIt<ShowGameEndNotificationUseCase>(),
      ));
}
