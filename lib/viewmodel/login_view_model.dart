import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:warehouse_management/models/user.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';


class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordObscure = true;
  bool isLoading = false;
  String? errorMessage;

  final LocalAuthentication _auth = LocalAuthentication();

  LoginViewModel() {
    emailController.addListener(() {
      _trimControllerText(emailController);
    });
    passwordController.addListener(() {
      _trimControllerText(passwordController);
    });
  }

  void _trimControllerText(TextEditingController controller) {
    final trimmed = controller.text.replaceFirst(RegExp(r'^[ ]+'), '');
    if (controller.text != trimmed) {
      controller.text = trimmed;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    notifyListeners();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Please enter both email and password';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final hashedPassword = _hashPassword(password);
    final userBox = Hive.box<User>('users');

    final userExists = userBox.values.any(
          (u) => u.email == email && u.password == hashedPassword,
    );

    if (userExists) {
      final authBox = Hive.box('authBox');
      authBox.put('isLoggedIn', true);
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      isLoading = false;
      errorMessage = 'Invalid email or password';
      notifyListeners();
      return false;
    }

  }


  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }



  Future<bool> loginWithBiometrics() async {
    try {
      final canAuthenticate = await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
      if (!canAuthenticate) {
        errorMessage = 'Biometric authentication not available';
        notifyListeners();
        return false;
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuthenticate) {
        final authBox = Hive.box('authBox');
        authBox.put('isLoggedIn', true);
        return true;
      } else {
        errorMessage = 'Authentication failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Biometric Error: $e';
      notifyListeners();
      return false;
    }
  }

  void reset() {
    emailController.clear();
    passwordController.clear();
    isPasswordObscure = true;
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }



  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

