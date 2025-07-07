import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_it/get_it.dart';
import 'package:wrapd/app/theme/app_colors.dart';
import 'package:wrapd/features/auth/domain/usecases/get_login_url.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_event.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_state.dart';
import 'package:package_info_plus/package_info_plus.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AppLinks _appLinks = AppLinks();
  bool _hasNavigated = false;
  String _version = '';


  @override
  void initState() {
    super.initState();
    _listenToAppLinks();
    _loadVersion();

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

  void _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${info.version}';
    });
  }

  void _launchGitHubLogin() {
    final loginUrl = GetIt.I<GetLoginUrl>()();
    launchUrl(Uri.parse(loginUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    void _showHelpSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        backgroundColor: colors.brandPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Wrapd will only access public contributions of your GitHub profile.",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    const url =
                        'https://docs.github.com/en/rest/permissions'; // update with your actual link
                    if (await canLaunchUrl(Uri.parse(url))) {
                      launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: const Text(
                    "View GitHub permissions",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "developed by devpedrofurquim",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        },
      );
    }

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
                    Image.asset(
                      'lib/assets/logo_wrapd.png',
                      width: 240,
                      height: 240,
                    ),

                    const SizedBox(height: 16),

                    // Continue with GitHub button or loader
                    if (state is AuthLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _launchGitHubLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: colors.brandPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Continue with Github"),
                      ),

                    const SizedBox(height: 24),

                    // Tagline
                    const Text(
                      "Code matters. Let's unwrap it.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 64),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_version, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.help,
                            size: 20,
                            color: colors.brandPrimary,
                          ),
                          onPressed: () {
                            _showHelpSheet(context);
                          },
                        ),
                      ],
                    ),
                    if (state is AuthFailure) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Login failed: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
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
