import 'package:bjp_app/config/app_theme_data.dart';
import 'package:bjp_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  // Track password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _setNewPassword() {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text;

    ref
        .read(authControllerProvider.notifier)
        .resetPassword(
          context,
          password: password,
          email: widget.email,
          otp: widget.otp,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemeData.lightThemeData,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    'নতুন পাসওয়ার্ড লিখুন',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 50.0),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text('পাসওয়ার্ড'),
                      hintText: 'এখানে লিখুন',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_isPasswordVisible, // Toggle obscure text
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'পাসওয়ার্ড দিন';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text('পাসওয়ার্ড নিশ্চিত করুন'),
                      hintText: 'এখানে লিখুন',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),

                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'পাসওয়ার্ড মেলেনি';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText:
                        !_isConfirmPasswordVisible, // Toggle obscure text
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _setNewPassword,
                    child: Text('পরবর্তী', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
