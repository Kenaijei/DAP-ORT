import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:tp4_dap/core/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(AuthService()),
);

class AuthState {
  final String? uid;
  final String? username;
  final String? photoUrl;
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;

  const AuthState({
    this.uid,
    this.username,
    this.photoUrl,
    this.isLoading = false,
    this.isInitialized = false,
    this.errorMessage,
  });

  AuthState copyWith({
    String? uid,
    String? username,
    String? photoUrl,
    bool? isLoading,
    bool? isInitialized,
    String? errorMessage,
  }) {
    return AuthState(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  late final StreamSubscription<User?> _authSubscription;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) => unawaited(_handleAuthChanged(user)),
      onError: (Object error) {
        state = state.copyWith(
          isInitialized: true,
          isLoading: false,
          errorMessage: _messageFor(error),
        );
      },
    );
  }

  Future<void> _handleAuthChanged(User? user) async {
    if (user == null) {
      state = const AuthState(isInitialized: true);
      return;
    }

    state = AuthState(
      uid: user.uid,
      username: user.displayName,
      photoUrl: user.photoURL ?? '',
      isLoading: true,
      isInitialized: true,
    );

    try {
      final profile = await _authService.loadProfile(user);
      if (FirebaseAuth.instance.currentUser?.uid != user.uid) return;
      state = AuthState(
        uid: user.uid,
        username: profile['username'] as String?,
        photoUrl: profile['photoUrl'] as String? ?? '',
        isInitialized: true,
      );
    } catch (error) {
      if (FirebaseAuth.instance.currentUser?.uid != user.uid) return;
      state = AuthState(
        uid: user.uid,
        username: user.displayName,
        photoUrl: user.photoURL ?? '',
        isInitialized: true,
        errorMessage: _messageFor(error),
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _authService.login(email, password);
      state = AuthState(
        uid: FirebaseAuth.instance.currentUser?.uid,
        username:
            profile['username'] as String? ?? email.trim().split('@').first,
        photoUrl: profile['photoUrl'] as String? ?? '',
        isInitialized: true,
      );
      return true;
    } catch (error) {
      state = AuthState(isInitialized: true, errorMessage: _messageFor(error));
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.register(name, email, password);
      state = const AuthState(isInitialized: true);
      return true;
    } catch (error) {
      state = AuthState(isInitialized: true, errorMessage: _messageFor(error));
      return false;
    }
  }

  Future<bool> updateProfilePhoto({
    required Uint8List imageBytes,
    required String contentType,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final photoUrl = await _authService.updateProfilePhoto(
        imageBytes: imageBytes,
        contentType: contentType,
      );
      state = state.copyWith(photoUrl: photoUrl, isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _messageFor(error),
      );
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _messageFor(error),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState(isInitialized: true);
  }

  @override
  void dispose() {
    unawaited(_authSubscription.cancel());
    super.dispose();
  }

  String _messageFor(Object error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' => 'Correo o contrasena incorrectos',
        'invalid-email' => 'Ingresa un correo valido',
        'weak-password' => 'La contrasena debe tener al menos 6 caracteres',
        'email-already-in-use' => 'Ese correo ya esta registrado',
        'requires-recent-login' =>
          'Vuelve a iniciar sesion antes de cambiar la contrasena',
        'network-request-failed' => 'No se pudo conectar. Revisa tu conexion',
        _ => error.message ?? 'Ocurrio un error de autenticacion',
      };
    }
    if (error is supabase.StorageException) {
      final statusCode = error.statusCode;
      final storageError = error.error;
      final details = [
        if (error.message.isNotEmpty) error.message,
        if (storageError != null && storageError.isNotEmpty) storageError,
      ].join(' — ');
      return 'Error al subir la foto a Supabase Storage'
          '${statusCode == null ? '' : ' ($statusCode)'}'
          '${details.isEmpty ? '' : ': $details'}';
    }
    if (error is supabase.AuthException) {
      return 'Error de autenticacion de Supabase'
          '${error.code == null ? '' : ' (${error.code})'}: ${error.message}';
    }
    if (error is FirebaseException) {
      return 'Error de Firebase (${error.code}): '
          '${error.message ?? 'No se pudo completar la operacion'}';
    }
    return 'No se pudo completar la operacion: $error';
  }
}
