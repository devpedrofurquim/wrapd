import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrapd/features/auth/presentation/pages/login_page.dart';
import 'package:wrapd/features/auth/presentation/pages/splash_page.dart';
import 'package:wrapd/features/story/presentation/pages/story_preview_page.dart';
import 'package:wrapd/features/summary/presentation/pages/summary_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
      GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(), // 👌 Entry point
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/summary',
      name: 'summary',
      builder: (context, state) => const SummaryPage(),
    ),
    GoRoute(
      path: '/story',
      name: 'storyPreview',
      builder: (context, state) => const StoryPreviewPage(),
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Page not found')),
  ),
);
