import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/light_theme.dart';
import 'core/constants/app_routes.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/tasks/screens/tasks_screen.dart';
import 'features/tasks/screens/add_task_screen.dart';
import 'features/tasks/screens/edit_task_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/notifications/screens/notifications_screen.dart';

class MomentumApp extends StatelessWidget {
  const MomentumApp({Key? key}) : super(key: key);

  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.tasks,
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: AppRoutes.addTask,
        builder: (context, state) => const AddTaskScreen(),
      ),
      GoRoute(
        path: AppRoutes.editTask,
        builder: (context, state) {
          final taskId = state.pathParameters['id'];
          return EditTaskScreen(taskId: taskId ?? '');
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Momentum',
      theme: lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
