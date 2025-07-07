import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wrapd/app/router.dart';
import 'package:wrapd/app/theme/app_theme.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wrapd/core/session/presentation/bloc/session_bloc.dart';
import 'package:wrapd/core/session/presentation/bloc/session_event.dart';

class WrapdApp extends StatelessWidget {
  const WrapdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionBloc>(
          create: (_) => GetIt.I<SessionBloc>()..add(SessionStarted()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => GetIt.I<AuthBloc>(),
        ),
        // Remove the duplicate AuthBloc provider
      ],
      child: MaterialApp.router(
        title: 'Wrapd',
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
