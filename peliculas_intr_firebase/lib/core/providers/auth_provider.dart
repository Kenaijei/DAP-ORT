import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tp4_dap/core/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(AuthService()),
);

class AuthState {
  final String? uid;
  final String? username;
  final String? photoUrl;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.uid,
    this.username,
    this.photoUrl,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    String? uid,
    String? username,
    String? photoUrl,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _authService.login(email, password);
      state = AuthState(
        uid: FirebaseAuth.instance.currentUser?.uid,
        username:
            profile['username'] as String? ?? email.trim().split('@').first,
        photoUrl: profile['photoUrl'] as String? ?? '',
      );
      return true;
    } catch (error) {
      state = AuthState(errorMessage: _messageFor(error));
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.register(email, password);
      state = const AuthState();
      return true;
    } catch (error) {
      state = AuthState(errorMessage: _messageFor(error));
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
    state = const AuthState();
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
    return 'No se pudo completar la operacion. Revisa tu conexion y las reglas de Firebase';
  }
}
