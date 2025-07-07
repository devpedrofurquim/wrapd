import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wrapd/core/session/presentation/bloc/session_bloc.dart';
import 'package:wrapd/core/session/presentation/bloc/session_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (_navigated) return;

        void navigateAfterDelay(String path) {
          _navigated = true;
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) context.go(path);
          });
        }

        if (state is SessionAuthenticated) {
          navigateAfterDelay('/summary');
        } else if (state is SessionUnauthenticated) {
          navigateAfterDelay('/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/logo_wrapd.png', width: 240, height: 240),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: Color(0xFF7A63BB)),
            ],
          ),
        ),
      ),
    );
  }
}
