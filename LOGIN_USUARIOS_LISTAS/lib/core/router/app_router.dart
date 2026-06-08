import 'package:go_router/go_router.dart';
import 'package:productos/screens/home_screen.dart';
import 'package:productos/screens/login_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(username: state.extra is String ? state.extra as String : null),
    ),
  ],
);