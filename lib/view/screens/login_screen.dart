import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/viewmodel/login_view_model.dart';

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

  void _onEmailChanged(String value) {
    final trimmed = value.replaceFirst(RegExp(r'^[ ]+'), '');
    if (emailController.text != trimmed) {
      emailController.text = trimmed;
      emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length),
      );
    }
  }

  void _onPasswordChanged(String value) {
    final trimmed = value.replaceFirst(RegExp(r'^[ ]+'), '');
    if (passwordController.text != trimmed) {
      passwordController.text = trimmed;
      passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: passwordController.text.length),
      );
    }
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    final success = await viewModel.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/on_board');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

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
                    const SizedBox(height: 50),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: AppColors.pureWhite,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      style: TextStyle(color: AppColors.pureWhite),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: _onEmailChanged,
                      decoration: loginInputDecoration(
                        label: 'E-mail',
                        prefixIcon: Icons.email,
                      ),
                      validator: (value) {
                        final trimmed = value?.trim();
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
                    const SizedBox(height: 25),
                    TextFormField(
                      style: TextStyle(color: AppColors.pureWhite),
                      controller: passwordController,
                      obscureText: _isPasswordObscure,
                      onChanged: _onPasswordChanged,
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
                      validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter password'
                          : null,
                    ),
                    if (viewModel.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: AppColors.alertColor),
                      ),
                    ],
                    const SizedBox(height: 19),
                    Row(
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppColors.pureWhite),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color:AppColors.primary),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 45),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pureBlack,
                          foregroundColor: AppColors.pureWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 69,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 5,
                        ),
                        onPressed: viewModel.isLoading
                            ? null
                            : () => _submit(context),
                        child: viewModel.isLoading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.pureWhite,
                          ),
                        )
                            : const Text(
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

