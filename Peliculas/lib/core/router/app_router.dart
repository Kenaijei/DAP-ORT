import 'package:go_router/go_router.dart';
import 'package:tp2_dap/entities/movie.dart';
import 'package:tp2_dap/screens/home_screen.dart';
import 'package:tp2_dap/screens/login_screen.dart';
import 'package:tp2_dap/screens/results_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final username = state.extra as String?;
        return HomeScreen(username: username);
      },
    ),
    GoRoute(
      path: '/movie-detail',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailsScreen(movie: movie);
      },
    ),
  ],
);
