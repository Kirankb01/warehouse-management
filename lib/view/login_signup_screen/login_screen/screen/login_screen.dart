import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/route_constants.dart';
import 'package:warehouse_management/viewmodel/login_view_model.dart';
import 'package:warehouse_management/view/login_signup_screen/shared_widget/text_field_decoration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    viewModel.errorMessage = null;
    viewModel.isLoading = false;
    viewModel.isBiometricAvailable().then((available) {
      setState(() {
        _biometricAvailable = available;
      });
    });
  }


  void _handleLogin(BuildContext context) async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    final success = await viewModel.login();
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, RouteNames.onBoard);
    }
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Taking notes-cuate.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const ColoredBox(
              color: Color(0x1AFFFFFF),
            ),
          ),

          // Login Form
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(89),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset('assets/login_img.png'),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Welcome to TrackIn',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your smart warehouse assistant',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: viewModel.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.black87),
                        decoration: loginInputDecoration(
                          label: 'E-mail',
                          prefixIcon: Icons.email,
                        ),
                        validator: (_) => null,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: viewModel.passwordController,
                        obscureText: viewModel.isPasswordObscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(context),
                        style: const TextStyle(color: Colors.black87),
                        decoration: loginInputDecoration(
                          label: 'Password',
                          prefixIcon: Icons.lock,
                          suffixIcon: IconButton(
                            icon: Icon(
                              viewModel.isPasswordObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black54,
                            ),
                            onPressed: viewModel.togglePasswordVisibility,
                          ),
                        ),
                        validator: (_) => null,
                      ),

                      if (viewModel.errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: AppColors.alertColor),
                        ),
                      ],

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RouteNames.signup);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pureBlack,
                          foregroundColor: AppColors.pureWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 64,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 6,
                        ),
                        onPressed:
                            viewModel.isLoading
                                ? null
                                : () => _handleLogin(context),
                        child:
                            viewModel.isLoading
                                ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                      ),

                      const SizedBox(height: 20),

                      if (_biometricAvailable) ...[
                        IconButton(
                          icon: const Icon(
                            Icons.fingerprint,
                            size: 36,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            Provider.of<LoginViewModel>(
                              context,
                              listen: false,
                            ).loginWithBiometrics().then((success) {
                              if (success) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteNames.onBoard,
                                );
                              } else {
                                final errorMsg =
                                    Provider.of<LoginViewModel>(
                                      context,
                                      listen: false,
                                    ).errorMessage;
                                if (errorMsg != null) {
                                  print(errorMsg);
                                }
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Login using fingerprint',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
