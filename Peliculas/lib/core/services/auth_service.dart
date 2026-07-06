import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _usersKey = 'registered_users';

  /// Registra un nuevo usuario
  /// Retorna true si se registró exitosamente, false si el usuario ya existe
  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    final users = _getUsers(prefs);
    
    // Verificar si el usuario ya existe
    if (users.containsKey(username)) {
      return false; // Usuario ya existe
    }
    
    // Agregar nuevo usuario
    users[username] = password;
    await prefs.setString(_usersKey, jsonEncode(users));
    return true;
  }

  /// Valida las credenciales del usuario
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _getUsers(prefs);
    
    if (users.containsKey(username)) {
      return users[username] == password;
    }
    return false;
  }

  /// Obtiene todos los usuarios registrados (útil para debugging)
  Future<List<String>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final users = _getUsers(prefs);
    return users.keys.toList();
  }

  /// Método privado para obtener el mapa de usuarios desde SharedPreferences
  Map<String, String> _getUsers(SharedPreferences prefs) {
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) {
      return {};
    }
    final decodedUsers = jsonDecode(usersJson) as Map<String, dynamic>;
    return decodedUsers.cast<String, String>();
  }

  /// Limpia todos los usuarios registrados (solo para testing)
  Future<void> clearAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
  }
}
