import 'package:agri_bot_control/features/auth/presentation/pages/forget_password_page.dart';
import 'package:agri_bot_control/features/auth/presentation/pages/login_page.dart';
import 'package:agri_bot_control/features/auth/presentation/pages/signUp_page.dart';
import 'package:agri_bot_control/features/auth/presentation/pages/splash_page.dart';
import 'package:agri_bot_control/features/auth/presentation/pages/verify_email.dart';
import 'package:agri_bot_control/presentation/pages/alerts_page.dart';
import 'package:agri_bot_control/presentation/pages/dashboard_page.dart';
import 'package:agri_bot_control/presentation/pages/manual_control_page.dart';
import 'package:agri_bot_control/presentation/pages/setting_page.dart';
import 'package:agri_bot_control/presentation/pages/task_scheduler_page.dart';
import 'package:agri_bot_control/shared/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Track current tab
final ValueNotifier<int> bottomNavIndex = ValueNotifier<int>(0);

bool isLoggedIn() => FirebaseAuth.instance.currentUser != null;

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
      redirect: (context, state) => isLoggedIn() ? '/dashboard' : '/login',
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: ValueListenableBuilder<int>(
            valueListenable: bottomNavIndex,
            builder: (context, index, _) {
              return BottomNavBar(
                currentIndex: index,
                onTap: (i) {
                  bottomNavIndex.value = i;
                  switch (i) {
                    case 0:
                      context.go('/dashboard');
                      break;
                    case 1:
                      context.go('/control');
                      break;
                    case 2:
                      context.go('/alerts');
                      break;
                    case 3:
                      context.go('/settings');
                      break;

                  }
                },
              );
            },
          ),
        );
      },

      routes: [
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const TaskSchedulerPage(),
          redirect: (context, state) =>
              isLoggedIn() ? null : '/login',          
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
          redirect: (context, state) =>
              isLoggedIn() ? null : '/login',
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
          redirect: (context, state) =>
              isLoggedIn() ? null : '/login',
        ),
        GoRoute(
          path: '/control',
          builder: (context, state) => const ManualControlPage(),
          redirect: (context, state) =>
              isLoggedIn() ? null : '/login',
        ),
        GoRoute(
          path: '/alerts',
          builder: (context, state) => const AlertsPage(),
          redirect: (context, state) =>
              isLoggedIn() ? null : '/login',
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupPage(),
          redirect: (context, state) =>
              isLoggedIn() ? '/dashboard' : null,
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
          redirect: (context, state) =>
              isLoggedIn() ? '/dashboard' : null,
        ),
        GoRoute(
          path: '/verify-email',
          builder: (context, state) => const VerifyEmailPage(),
          redirect: (context, state) =>
              isLoggedIn() ? null : '/login',
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
          redirect: (context, state) =>
              isLoggedIn() ? '/dashboard' : null,
        ),
      ],
    ),
  ],
);
