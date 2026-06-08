class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Map<String, String> _users = {
    'user1@gmail.com': 'Passw0rd!',
    'user2@gmail.com': 'Admin@123',
    'user3@gmail.com': 'HelloW0rld!',
    'user4@gmail.com': 'Flutter#2026',
    'user5@gmail.com': 'Dartlover09#',
    'user6@gmail.com': 'KlaseA34HT!',
    'user7@gmail.com': 'MyPass#2026',
    'user8@gmail.com': 'Ort!!123',
    'user9@gmail.com': '1000Ton!',
    'user10@gmail.com': 'UserOne@1',
  };

  bool validate(String email, String password) {
    if (!_users.containsKey(email)) return false;
    return _users[email] == password;
  }

  List<String> listUsers() => _users.keys.toList();
}
