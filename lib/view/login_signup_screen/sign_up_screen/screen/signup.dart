import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/route_constants.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/viewmodel/sign_up_view_model.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  void _preventLeadingSpaces(TextEditingController controller, String value) {
    if (value.startsWith(' ')) {
      controller.text = value.trimLeft();
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final error = await SignupViewModel().registerUser(
      username: userNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (error != null) {
      showSnackBar(context, error, backgroundColor: AppColors.firebrickRed);
    } else {
      showSuccessSnackBar(context, 'Registration successful!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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

          // blur layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: const Color.fromARGB(25, 255, 255, 255)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.08),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(140),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset('assets/login_img.png'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome to TrackIn',
                          style: TextStyle(
                            fontFamily: 'RobotoCustom',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Create your account',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: userNameController,
                          style: const TextStyle(color: Colors.black87),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: loginInputDecoration(
                            label: 'Full Name',
                            prefixIcon: Icons.person,
                          ),
                          onChanged:
                              (val) => _preventLeadingSpaces(
                                userNameController,
                                val,
                              ),
                          validator:
                              (val) =>
                                  val == null || val.trim().isEmpty
                                      ? 'Enter username'
                                      : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black87),
                          textInputAction: TextInputAction.next,
                          decoration: loginInputDecoration(
                            label: 'E-mail',
                            prefixIcon: Icons.email,
                          ),
                          onChanged:
                              (val) =>
                                  _preventLeadingSpaces(emailController, val),
                          validator: (val) {
                            final trimmed = val?.trim();
                            if (trimmed == null || trimmed.isEmpty) {
                              return 'Enter email';
                            }
                            final emailRegex = RegExp(
                              r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(trimmed)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: passwordController,
                          obscureText: _isPasswordObscure,
                          style: const TextStyle(color: Colors.black87),
                          textInputAction: TextInputAction.next,
                          decoration: loginInputDecoration(
                            label: 'Password',
                            prefixIcon: Icons.lock,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.semiTransparentBlack,
                              ),
                              onPressed:
                                  () => setState(
                                    () =>
                                        _isPasswordObscure =
                                            !_isPasswordObscure,
                                  ),
                            ),
                          ),
                          onChanged:
                              (val) => _preventLeadingSpaces(
                                passwordController,
                                val,
                              ),
                          validator: (val) {
                            final trimmed = val?.trim();
                            if (trimmed == null || trimmed.isEmpty) {
                              return 'Enter password';
                            }
                            if (trimmed.length < 8) {
                              return 'Minimum 8 characters';
                            }
                            if (!RegExp(r'[A-Z]').hasMatch(trimmed)) {
                              return 'Include uppercase letter';
                            }
                            if (!RegExp(r'[a-z]').hasMatch(trimmed)) {
                              return 'Include lowercase letter';
                            }
                            if (!RegExp(r'[0-9]').hasMatch(trimmed)) {
                              return 'Include a number';
                            }
                            if (!RegExp(
                              r'[!@#$%^&*(),.?":{}|<>]',
                            ).hasMatch(trimmed)) {
                              return 'Include special character';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _isConfirmPasswordObscure,
                          style: const TextStyle(color: Colors.black87),
                          decoration: loginInputDecoration(
                            label: 'Confirm Password',
                            prefixIcon: Icons.lock,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.semiTransparentBlack,
                              ),
                              onPressed:
                                  () => setState(
                                    () =>
                                        _isConfirmPasswordObscure =
                                            !_isConfirmPasswordObscure,
                                  ),
                            ),
                          ),
                          onChanged:
                              (val) => _preventLeadingSpaces(
                                confirmPasswordController,
                                val,
                              ),
                          validator: (val) {
                            final trimmed = val?.trim();
                            if (trimmed == null || trimmed.isEmpty) {
                              return 'Enter confirm password';
                            }
                            if (trimmed != passwordController.text.trim()) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        Wrap(
                          spacing: screenWidth * 0.02,
                          runSpacing: 4,
                          children: [
                            const Text(
                              'By continuing you agree to our',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const Text(
                              'Terms of Service',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              'and',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pureBlack,
                              foregroundColor: AppColors.pureWhite,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 6,
                            ),
                            onPressed: _registerUser,
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteNames.login,
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
