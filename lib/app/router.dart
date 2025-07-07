import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrapd/core/utils/home_shell.dart';
import 'package:wrapd/features/auth/presentation/pages/login_page.dart';
import 'package:wrapd/features/auth/presentation/pages/splash_page.dart';
import 'package:wrapd/features/story/presentation/pages/story_preview_page.dart';
import 'package:wrapd/features/summary/presentation/pages/summary_page.dart';


final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    /// Unauthenticated routes
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    /// Authenticated routes with BottomNavigationBar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: '/summary',
          name: 'summary',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SummaryPage()),
        ),
        GoRoute(
          path: '/timeline',
          name: 'timeline',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: Placeholder()),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: Placeholder()),
        ),
      ],
    ),

    /// Independent route (not part of tab shell)
    GoRoute(
      path: '/story',
      builder: (context, state) => const StoryPreviewPage(),
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Page not found')),
  ),
);
