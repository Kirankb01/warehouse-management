import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/models/user.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final userBox = Hive.box<User>('users');
    User? matchedUser;

    try {
      matchedUser = userBox.values.firstWhere(
            (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      matchedUser = null;
    }

    isLoading = false;

    if (matchedUser != null) {
      final box = Hive.box('authBox');
      box.put('isLoggedIn', true);
      notifyListeners();
      return true;
    } else {
      errorMessage = 'Invalid email or password';
      notifyListeners();
      return false;
    }
  }
}
