import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/light_theme.dart';
import 'core/constants/app_routes.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/main/screens/main_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/tasks/screens/add_task_screen.dart';
import 'features/tasks/screens/edit_task_screen.dart';
import 'features/tasks/screens/task_details_screen.dart';
import 'features/profile/screens/edit_profile_screen.dart';
import 'features/settings/screens/settings_screen.dart';

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
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) => const MainScreen(),
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
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
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
        path: AppRoutes.taskDetails,
        builder: (context, state) {
          final taskId = state.pathParameters['id'];
          return TaskDetailsScreen(taskId: taskId ?? '');
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Momentum',
      theme: darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
