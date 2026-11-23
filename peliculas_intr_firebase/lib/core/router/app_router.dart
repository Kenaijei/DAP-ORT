import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tp4_dap/core/providers/auth_provider.dart';
import 'package:tp4_dap/entities/movie.dart';
import 'package:tp4_dap/screens/home_screen.dart';
import 'package:tp4_dap/screens/login_screen.dart';
import 'package:tp4_dap/screens/movie_details_screen.dart';
import 'package:tp4_dap/screens/profile_screen.dart';
import 'package:tp4_dap/screens/sign_up_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref.listen(authProvider, (_, _) => refreshNotifier.refresh());

  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      if (!authState.isInitialized) return null;

      final isLoggedIn = authState.uid != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/movie-detail',
        builder: (context, state) {
          final movie = state.extra as Movie;
          return MovieDetailsScreen(movie: movie);
        },
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refreshNotifier.dispose();
  });
  return router;
});

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}
