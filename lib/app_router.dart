
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/student/presentation/views/splash_view.dart';
import 'features/student/presentation/views/register_view.dart';
import 'features/student/presentation/views/login_view.dart';
import 'features/student/presentation/views/waiting_view.dart';
import 'features/student/presentation/views/home_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/waiting',
      name: 'waiting',
      builder: (context, state) => const WaitingView(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeView(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('حدث خطأ')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('تعذر فتح الصفحة المطلوبة.'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.go('/register'),
            child: const Text('العودة للتسجيل'),
          ),
        ],
      ),
    ),
  ),
);
