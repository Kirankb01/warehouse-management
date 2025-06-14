import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/user.dart';
import 'package:warehouse_management/utils/helpers.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool _isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset('assets/login_img.png'),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: loginInputDecoration(
                        label: 'E-mail',
                        prefixIcon: Icons.email,
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
                    SizedBox(height: 25),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
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
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscure = !_isPasswordObscure;
                            });
                          },
                        ),
                      ),

                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter password'
                                  : null,
                    ),
                    SizedBox(height: 19),
                    Row(
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/signup',
                            ); // Check your actual route name
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 45),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 69,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final loginEmail = emailController.text.trim();
                            final loginPassword =
                                passwordController.text.trim();

                            final userBox = Hive.box<User>('users');

                            User? matchedUser;
                            try {
                              matchedUser = userBox.values.firstWhere(
                                (user) =>
                                    user.email == loginEmail &&
                                    user.password == loginPassword,
                              );
                            } catch (e) {
                              matchedUser = null;
                            }

                            if (matchedUser != null) {
                              final box = Hive.box('authBox');
                              box.put('isLoggedIn', true);
                              Navigator.pushReplacementNamed(
                                context,
                                '/on_board',
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid email or password'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
