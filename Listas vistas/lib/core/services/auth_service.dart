class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final List<String> _userList = [
    'user1@gmail.com',
    'user2@gmail.com',
    'user3@gmail.com',
    'user4@gmail.com',
    'user5@gmail.com',
    'user6@gmail.com',
    'user7@gmail.com',
    'user8@gmail.com',
    'user9@gmail.com',
    'user10@gmail.com',
  ];

  final Map<String, String> _credentials = {
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
    for (final userEmail in _userList) {
      if (userEmail == email) {
        return _credentials[email] == password;
      }
    }
    return false;
  }

  List<String> listUsers() => List.unmodifiable(_userList);
}
