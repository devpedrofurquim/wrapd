import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wrapd/app/router.dart';
import 'package:wrapd/app/theme/app_theme.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_bloc.dart';

class WrapdApp extends StatelessWidget {
  const WrapdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => GetIt.I<AuthBloc>(),
        ),
        // Add other blocs here:
        // BlocProvider<OtherBloc>(create: (_) => GetIt.I<OtherBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Wrapd',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
