import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Core
import 'package:wrapd/core/storage/token_storage.dart';
import 'package:wrapd/features/auth/data/repositories/auth_repository_implementation.dart';

// Data

// Domain
import 'package:wrapd/features/auth/domain/repositories/auth_repository.dart';
import 'package:wrapd/features/auth/domain/usecases/get_login_url.dart';
import 'package:wrapd/features/auth/domain/usecases/login_w_github.dart';
import 'package:wrapd/features/auth/domain/usecases/read_saved_token.dart';

// Presentation
import 'package:wrapd/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  // 🔗 External dependencies
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton(() => TokenStorage());

  // 🧠 Domain <--> Data binding
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<Dio>(), sl<TokenStorage>()),
  );

  // ✅ Use Cases
  sl.registerLazySingleton(() => LoginWithGithub(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetLoginUrl(sl()));
  sl.registerLazySingleton(() => ReadSavedToken(sl()));

  // 🎯 BLoC
  sl.registerFactory(
    () => AuthBloc(sl<LoginWithGithub>(), sl<ReadSavedToken>()),
  );
}
