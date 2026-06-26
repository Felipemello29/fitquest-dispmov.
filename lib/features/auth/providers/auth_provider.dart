import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';

// Mocked database of users
const _mockUsers = [
  AuthUser(
    id: '1',
    email: 'free@test.com',
    Senha: '123',
    accountLevel: AccountLevel.free,
  ),
  AuthUser(
    id: '2',
    email: 'premium@test.com',
    Senha: '123',
    accountLevel: AccountLevel.premium,
  ),
  AuthUser(
    id: '3',
    email: 'admin@test.com',
    Senha: '123',
    accountLevel: AccountLevel.admin,
  ),
];

class AuthNotifier extends Notifier<AuthUser?> {
  @override
  AuthUser? build() {
    return null;
  }

  Future<void> login(String email, String Senha) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _mockUsers.firstWhere(
        (u) => u.email == email && u.Senha == Senha,
      );
      state = user;
    } catch (e) {
      throw Exception('Invalid email or Senha');
    }
  }

  void logout() {
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthUser?>(AuthNotifier.new);
