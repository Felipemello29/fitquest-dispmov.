enum AccountLevel {
  free,
  premium,
  admin,
}

class AuthUser {
  final String id;
  final String email;
  final String password;
  final AccountLevel accountLevel;

  const AuthUser({
    required this.id,
    required this.email,
    required this.password,
    required this.accountLevel,
  });
}
