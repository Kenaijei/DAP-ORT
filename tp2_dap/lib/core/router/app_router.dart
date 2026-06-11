import 'package:go_router/go_router.dart';
import 'package:tp2_dap/screens/home_screen.dart';
import 'package:tp2_dap/screens/login_screen.dart';
import 'package:tp2_dap/screens/results_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final username = state.extra as String?;
        return HomeScreen(username: username);
      },
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) {
        final results = state.extra as Map<String, dynamic>;
        return ResultsScreen(results: results);
      },
    ),
  ],
);
