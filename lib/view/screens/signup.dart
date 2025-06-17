import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/user.dart';
import 'package:warehouse_management/utils/helpers.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.08), // 8% padding
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: screenHeight * 0.1, // 10% of screen height
                    width: screenHeight * 0.1,
                    child: Image.asset('assets/login_img.png'),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05), // 5% of screen height
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.09, // ~36px on 400px width
                  ),
                ),
                Text(
                  'Enter your credentials to continue',
                  style: TextStyle(color: AppColors.pureWhite),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Full Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  style: TextStyle(color: AppColors.pureWhite),
                  controller: userNameController,
                  decoration: loginInputDecoration(
                    label: 'Username',
                    prefixIcon: Icons.person,
                  ),
                  validator: (value) {
                    final trimmedValue = value?.trim();
                    if (trimmedValue == null || trimmedValue.isEmpty) {
                      return 'Enter username';
                    }
                    if (value!.startsWith(' ')) {
                      return 'Cannot start with space';
                    }
                    return null;
                  },

                ),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  'E-mail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  style: TextStyle(color: AppColors.pureWhite),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: loginInputDecoration(
                    label: 'E-mail',
                    prefixIcon: Icons.alternate_email,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter email';
                    }

                    // Basic email regex
                    final emailRegex = RegExp(
                      r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  style: TextStyle(color: AppColors.pureWhite),
                  controller: passwordController,
                  obscureText: _isPasswordObscure,
                  decoration: loginInputDecoration(
                    label: 'Password',
                    prefixIcon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.pureWhite,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscure = !_isPasswordObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    final trimmed = value?.trim();
                    if (trimmed == null || trimmed.isEmpty) {
                      return 'Enter password';
                    }
                    if (trimmed.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(trimmed)) {
                      return 'Password must have at least one uppercase letter';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(trimmed)) {
                      return 'Password must have at least one lowercase letter';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(trimmed)) {
                      return 'Password must contain a number';
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(trimmed)) {
                      return 'Password must contain a special character';
                    }
                    return null;
                  },
                ),

                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),

                // State variable
                TextFormField(
                  style: TextStyle(color: AppColors.pureWhite),
                  controller: confirmPasswordController,
                  obscureText: _isConfirmPasswordObscure,
                  decoration: loginInputDecoration(
                    label: 'Confirm Password',
                    prefixIcon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.pureWhite,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordObscure =
                              !_isConfirmPasswordObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    final trimmed = value?.trim();
                    if (trimmed == null || trimmed.isEmpty) {
                      return 'Enter confirm password';
                    }
                    if (trimmed != passwordController.text.trim()) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: screenHeight * 0.024),
                Wrap(
                  spacing: screenWidth * 0.02,
                  runSpacing: 4,
                  children: [
                    Text(
                      'By continuing you agree to our',
                      style: TextStyle(color: AppColors.pureWhite),
                    ),
                    Text(
                      'Terms of Service',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    Text('and', style: TextStyle(color: AppColors.pureWhite)),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.07),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pureBlack,
                      foregroundColor: AppColors.pureWhite,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.20, // 11% of screen width
                        vertical: screenHeight * 0.020,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final userBox = Hive.box<User>('users');

                        final emailExists = userBox.values.any(
                          (user) => user.email == emailController.text.trim(),
                        );

                        if (emailExists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Email already registered')),
                          );
                          return;
                        }

                        final newUser = User(
                          username: userNameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        await userBox.add(newUser);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration successful!')),
                        );

                        Navigator.pop(context); // Go back to login page
                      }
                    },

                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
