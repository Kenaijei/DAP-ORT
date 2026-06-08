import 'package:go_router/go_router.dart';
import '../../screens/products_screens.dart';
import '../../screens/home_screen.dart';
import '../../screens/login_screen.dart';

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