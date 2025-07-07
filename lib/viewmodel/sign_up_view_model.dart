import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/models/user.dart';

class SignupViewModel {
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final userBox = Hive.box<User>('users');
    final emailExists = userBox.values.any((user) => user.email == email);
    if (emailExists) return 'Email already registered';

    final hashedPassword = _hashPassword(password);
    final newUser = User(username: username, email: email, password: hashedPassword);
    await userBox.add(newUser);
    return null;
  }
}
