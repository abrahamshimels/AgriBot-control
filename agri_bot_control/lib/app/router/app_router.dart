import 'package:agri_bot_control/presentation/pages/alerts_page.dart';
import 'package:agri_bot_control/presentation/pages/dashboard_page.dart';
import 'package:agri_bot_control/presentation/pages/manual_control_page.dart';
import 'package:agri_bot_control/presentation/pages/setting_page.dart';
import 'package:agri_bot_control/presentation/pages/task_scheduler_page.dart';
import 'package:agri_bot_control/shared/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Track current tab
final ValueNotifier<int> bottomNavIndex = ValueNotifier<int>(0);

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
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
                      context.go('/tasks');
                      break;
                    case 2:
                      context.go('/control');
                      break;
                    case 3:
                      context.go('/alerts');
                      break;
                    case 4:
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
          builder: (context, state) => TaskSchedulerPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/control',
          builder: (context, state) => const ManualControlPage(),
        ),
        GoRoute(
          path: '/alerts',
          builder: (context, state) => const AlertsPage(),
        ),
      ],
    ),
  ],
);
