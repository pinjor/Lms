import 'dart:convert';

import 'package:bjp_app/config/app_colors.dart';
import 'package:bjp_app/config/app_theme_data.dart';
import 'package:bjp_app/dataRepository/global.dart';
import 'package:bjp_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bjp_app/features/auth/presentation/screens/enter_email_screen.dart';
import 'package:bjp_app/features/auth/presentation/screens/register_screen.dart';
import 'package:bjp_app/features/home/presentation/screens/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/route_path.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/login_response_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailOrMobileController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isAdminLogin = false;
  late final Dio _dioClient;
  late final FlutterSecureStorage _secureStorage;

  @override
  void initState() {
    super.initState();
    _dioClient = Dio();
    _secureStorage = const FlutterSecureStorage();
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final mobileOrEmail = _emailOrMobileController.text.trim();
      final password = _passwordController.text.trim();

      lgr.i('Login request sending..: ');
      try {
        final uri = Uri(
          scheme: 'http',
          port: ApiConstants.port,
          host: ApiConstants.baseUrl,
          path: _isAdminLogin ? ApiConstants.adminLogin : ApiConstants.login,
        );
        lgr.i('Login request sending to: ${uri.toString()}');
        final response = await _dioClient.post(
          uri.toString(),
          data:
              _isAdminLogin
                  ? {'email': mobileOrEmail, 'password': password}
                  : {'phone_number': mobileOrEmail, 'password': password},
        );

        lgr.i('Login response received: ${response.data}');

        final loginResponse = LoginResponseModel.fromJson(response.data);
        if (response.statusCode == 200) {
          lgr.i('Token received: ${loginResponse.token}');
          token = loginResponse.token!;
          user = jsonEncode(loginResponse.user?.toJson());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          return null;
        }
      } catch (e) {
        print('Login error: $e');
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

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
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                      //Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 50.0),
                    TextFormField(
                      controller: _emailOrMobileController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        label: Text(_isAdminLogin ? 'ইমেইল*' : 'মোবাইল নম্বর*'),
                        hintText: 'এখানে লিখুন',
                      ),
                      keyboardType:
                          _isAdminLogin
                              ? TextInputType.emailAddress
                              : TextInputType.phone,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return _isAdminLogin
                              ? 'ইমেইল দিন'
                              : 'মোবাইল নম্বর দিন';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'পাসওয়ার্ড দিন';
                        }
                        return null;
                      },
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
                            //GoRouter.of(context).push(RoutePath.enterEmailScreenPath);
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
                    if (authState.isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _loginUser,
                        child: const Text(
                          'লগইন',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (authState.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          authState.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 75),
                      child: Row(
                        children: [
                          const Text('অ্যাকাউন্ট নেই? এখনই'),
                          TextButton(
                            onPressed: ()
                            {
                              context.pushReplacement(RoutePath.enterEmailScreenPath);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => RegisterScreen(),
                              //   ),
                              // );
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
