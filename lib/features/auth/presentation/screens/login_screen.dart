// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:bjp_app/features/home/presentation/screens/home_screen.dart';
import 'package:bjp_app/features/auth/presentation/screens/enter_email_screen.dart';
import 'package:bjp_app/features/auth/presentation/screens/register_screen.dart';
import 'package:bjp_app/config/app_colors.dart';
import 'package:bjp_app/config/app_theme_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrMobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isAdminLogin = false;

  void _loginUser() {
    // Simply navigate to HomeScreen without any authentication
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemeData.lightThemeData,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _isAdminLogin ? 'অ্যাডমিন' : 'সদস্য',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Switch(
                            activeColor: AppColors.themeColor,
                            value: _isAdminLogin,
                            onChanged: (bool value) {
                              setState(() {
                                _isAdminLogin = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    Text(
                      _isAdminLogin ? 'অ্যাডমিন লগইন' : 'সদস্য লগইন',
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    TextFormField(
                      controller: _emailOrMobileController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        label: Text(_isAdminLogin ? 'ইমেইল*' : 'মোবাইল নম্বর*'),
                        hintText: 'এখানে লিখুন',
                      ),
                      keyboardType: _isAdminLogin
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      controller: _passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        label: const Text('পাসওয়ার্ড*'),
                        hintText: 'এখানে লিখুন',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnterEmailScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'পাসওয়ার্ড ভুলে গেছেন ?',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _loginUser,
                      child: const Text(
                        'লগইন',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 75),
                      child: Row(
                        children: [
                          const Text('অ্যাকাউন্ট নেই? এখনই'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text('মেম্বার হোন'),
                          ),
                        ],
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