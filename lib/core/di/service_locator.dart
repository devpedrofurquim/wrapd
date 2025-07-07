import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:wrapd/core/session/presentation/bloc/session_bloc.dart';

// Core
import 'package:wrapd/core/storage/token_storage.dart';
import 'package:wrapd/features/auth/data/repositories/auth_repository_implementation.dart';

// Auth Domain
import 'package:wrapd/features/auth/domain/repositories/auth_repository.dart';
import 'package:wrapd/features/auth/domain/usecases/get_login_url.dart';
import 'package:wrapd/features/auth/domain/usecases/login_w_github.dart';
import 'package:wrapd/features/auth/domain/usecases/read_saved_token.dart';

// Summary Domain
import 'package:wrapd/features/summary/data/repositories/github_repository_impl.dart';
import 'package:wrapd/features/summary/domain/repositories/github_repository.dart';
import 'package:wrapd/features/summary/domain/usecases/get_current_user.dart';

// Presentation
import 'package:wrapd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wrapd/features/summary/presentation/bloc/summary_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  // 🔗 External dependencies
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Core storage
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl<FlutterSecureStorage>()),
  );

  // 🧠 Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<Dio>(), sl<TokenStorage>()),
  );
  
  sl.registerLazySingleton<GitHubRepository>(
    () => GitHubRepositoryImpl(sl<Dio>()),
  );

  // ✅ Use Cases
  sl.registerLazySingleton(() => LoginWithGithub(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetLoginUrl(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ReadSavedToken(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUser(sl<GitHubRepository>()));

  // Session Bloc
  sl.registerLazySingleton<SessionBloc>(
    () => SessionBloc(sl<ReadSavedToken>()),
  );

  // 🎯 BLoCs
  sl.registerFactory(
    () => AuthBloc(
      sl<LoginWithGithub>(),
      sl<ReadSavedToken>(),
      sl<SessionBloc>(),
    ),
  );
  
  sl.registerFactory(() => SummaryBloc(sl<GetCurrentUser>()));
}
