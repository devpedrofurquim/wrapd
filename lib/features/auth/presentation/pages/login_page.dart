import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrapd/features/auth/domain/usecases/get_login_url.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_event.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_state.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AppLinks _appLinks = AppLinks();
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _listenToAppLinks();
  }

  void _listenToAppLinks() {
    final authBloc = context.read<AuthBloc>();
    _appLinks.uriLinkStream.listen((Uri? uri) {
      final code = uri?.queryParameters['code'];
      if (code != null) {
        authBloc.add(AuthCodeReceived(code));
      }
    });
  }

  void _launchGitHubLogin() {
    final loginUrl = GetIt.I<GetLoginUrl>()();
    launchUrl(Uri.parse(loginUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthSucess && !_hasNavigated) {
                  _hasNavigated = true;
                  Future.microtask(() {
                    if (mounted) context.go('/summary');
                  });
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '👋 Welcome to Wrapd',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your GitHub year, beautifully wrapped.\nLogin to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    if (state is AuthLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton.icon(
                        onPressed: _launchGitHubLogin,
                        icon: const Icon(Icons.login),
                        label: const Text('Continue with GitHub'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      ),
                    if (state is AuthFailure) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Login failed: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (state is AuthSucess) ...[
                      const SizedBox(height: 16),
                      const Text('✅ Logged in successfully!'),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
