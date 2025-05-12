// lib/features/auth/presentation/controllers/auth_controller.dart

import 'dart:async';
import 'dart:convert';

import 'package:bjp_app/features/auth/data/auth_repository.dart';
import 'package:bjp_app/features/auth/domain/login_response_model.dart';
import 'package:bjp_app/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/auth_state.dart';
import '../../domain/register_input_model.dart';
import '../screens/reset_password_screen.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _checkInitialState(); // Check if user is already logged in e.g. current session or auth state
    return AuthState(status: AuthStatus.unknown);
  }

  Future<void> _checkInitialState() async {
    final token = await _authRepository.getToken();
    final userJson = await _authRepository.getUser();
    if (token != null && userJson != null) {
      lgr.i('User already logged in, token: $token');
      final user = User.fromJson(jsonDecode(userJson));
      final loginResponse = LoginResponseModel(user: user, token: token);
      _authRepository.setAuthStateController = loginResponse;
      state = AuthState(user: loginResponse, status: AuthStatus.authenticated);
    } else {
      state = AuthState(
        status: AuthStatus.unauthenticated,
      ); // Default to unauthenticated state
      lgr.i('User not logged in yet');
    }
  }

  void login({
    required String mobileOrEmail,
    required String password,
    required bool isAdmin,
  }) async {
    state = AuthState(isLoading: true, status: AuthStatus.unauthenticated);
    try {
      final result = await _authRepository.login(
        mobileOrEmail: mobileOrEmail,
        password: password,
        isAdmin: isAdmin,
      );
      if (result != null && result.token != null) {
        // Set the user and authenticated status after a successful login
        state = AuthState(user: result, status: AuthStatus.authenticated);
      } else {
        state = AuthState(
          error: 'লগইন ব্যর্থ: ভুল মোবাইল নম্বর বা পাসওয়ার্ড',
          status: AuthStatus.unauthenticated,
        );
      }
    } catch (e) {
      state = AuthState(
        error: 'Login error: $e',
        status: AuthStatus.unauthenticated,
      );
    }
  }

  void register(
    BuildContext context, {
    required RegisterInputModel data,
  }) async {
    state = AuthState(isLoading: true, status: AuthStatus.unauthenticated);

    final result = await _authRepository.register(data: data);

    result.fold(
      (failure) async {
        state = AuthState(
          error: 'Registration error: ${failure.message}',
          status: AuthStatus.unauthenticated,
        );
        // Show the detailed error dialog:
        await showErrorDialog(
          context,
          errorMessage: failure.message,
          title: 'নিবন্ধন ব্যর্থ',
        );
      },
      (r) {
        state = AuthState(status: AuthStatus.unauthenticated);
        showMessageToUser(
          context: context,
          message: 'সফলভাবে নিবন্ধিত হয়েছে, লগইন করুন',
        );
        context.pop();
      },
    );
  }

  void sendOTPToEmail(BuildContext context, {required String email}) async {
    state = AuthState(isLoading: true, status: AuthStatus.unauthenticated);

    final result = await _authRepository.sendOTPToEmail(email: email);

    result.fold(
      (failure) async {
        state = AuthState(
          error: 'Send OTP error: ${failure.message}',
          status: AuthStatus.unauthenticated,
        );

        lgr.i('OTP sent failed got response');

        // Show the detailed error dialog:
        await showErrorDialog(
          context,
          errorMessage: failure.message,
          title: 'ওটিপি পাঠাতে ব্যর্থ হয়েছে',
        );
      },
      (r) {
        lgr.i('OTP sent successfully got response');
        state = AuthState(status: AuthStatus.unauthenticated);
        showMessageToUser(
          context: context,
          message: 'ওটিপি পাঠানো হয়েছে, আপনার ইমেইল চেক করুন',
        );
        // context.go(RoutePath.verifyOtpScreenPath);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVeificationScreen(email: email),
          ),
        );
      },
    );
  }

  void verifyOTP(
    BuildContext context, {
    required String otp,
    required String email,
  }) async {
    final result = await _authRepository.verifyOTP(otp: otp, email: email);

    result.fold(
      (failure) async {
        state = AuthState(
          error: 'Verify OTP error: ${failure.message}',
          status: AuthStatus.unauthenticated,
        );

        // Show the detailed error dialog:
        await showErrorDialog(
          context,
          errorMessage: failure.message,
          title: 'ওটিপি যাচাই করতে ব্যর্থ হয়েছে',
        );
      },
      (r) {
        state = AuthState(status: AuthStatus.unauthenticated);
        showMessageToUser(
          context: context,
          message: 'ওটিপি সফলভাবে যাচাই করা হয়েছে, পাসওয়ার্ড পরিবর্তন করুন',
        );
        // context.go(RoutePath.resetPasswordScreenPath);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email, otp: otp),
          ),
        );
      },
    );
  }

  void resetPassword(
    BuildContext context, {
    required String password,
    required String email,
    required String otp,
  }) async {
    final result = await _authRepository.resetPassword(
      email: email,
      otp: otp,
      password: password,
    );

    result.fold(
      (failure) async {
        state = AuthState(
          error: 'পাসওয়ার্ড রিসেট করতে ব্যর্থ হয়েছে: ${failure.message}',
          status: AuthStatus.unauthenticated,
        );

        // Show the detailed error dialog:
        await showErrorDialog(
          context,
          errorMessage: failure.message,
          title: 'পাসওয়ার্ড রিসেট করতে ব্যর্থ হয়েছে',
        );
      },
      (r) {
        state = AuthState(status: AuthStatus.unauthenticated);
        showMessageToUser(
          context: context,
          message: 'পাসওয়ার্ড সফলভাবে পরিবর্তন করা হয়েছে, লগইন করুন',
        );
        context.pop();
      },
    );
  }

  void logout() async {
    try {
      await _authRepository.logout();
      state = AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(
        error: 'Logout error: $e',
        status: AuthStatus.authenticated,
      );
    }
  }
}
