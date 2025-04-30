import 'dart:convert';

import 'package:bjp_app/core/type_defs.dart';
import 'package:bjp_app/core/utils/utils.dart';
import 'package:bjp_app/features/auth/domain/login_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/in_memory_store.dart';
import '../domain/register_input_model.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class AuthRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  final _authStateController = InMemoryStore<LoginResponseModel?>(null);

  // setter for authstatecontroller
  set setAuthStateController(LoginResponseModel? value) =>
      _authStateController.value = value;
  Stream<LoginResponseModel?> get authStateChanges =>
      _authStateController.stream;
  LoginResponseModel? get currentUser => _authStateController.value;

  Future<LoginResponseModel?> login({
    required String mobileOrEmail,
    required String password,
    required bool isAdmin,
  }) async {
    lgr.i('Login request sending..: ');
    try {
      //'http://116.68.206.157:9445/api/login',
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: isAdmin ? ApiConstants.adminLogin : ApiConstants.login,
      );
      lgr.i('Login request sending to: ${uri.toString()}');
      final response = await _dioClient.post(
        uri.toString(),
        data:
            isAdmin
                ? {'email': mobileOrEmail, 'password': password}
                : {'phone_number': mobileOrEmail, 'password': password},
      );

      lgr.i('Login response received: ${response.data}');

      final loginResponse = LoginResponseModel.fromJson(response.data);
      if (response.statusCode == 200) {
        lgr.i('Token received: ${loginResponse.token}');
        await saveUser(loginResponse);
        _authStateController.value = loginResponse;
        return loginResponse;
      } else {
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
    // return null;
  }

  FutureEitherVoid register({required RegisterInputModel data}) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.register,
      );

      lgr.i('Register request sending to: ${uri.toString()}');

      final response = await _dioClient.post(
        uri.toString(),
        data: data.toJson(),
      );

      lgr.i('Register response received: ${response.data}');

      if (response.statusCode == 201) {
        lgr.i('Register success');
        return right(null);
      } else {
        // Handle unexpected status codes if necessary
        lgr.f('Unexpected status code: ${response.statusCode}');
        return left(Failure('Unexpected error occurred'));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 422) {
        // Extract error messages from the response data
        final errorData = err.response!.data['data'] as Map<String, dynamic>;
        String errorMessage = '';
        errorData.forEach((field, messages) {
          errorMessage += '***${(messages as List).join(' ')}\n\n';
        });

        lgr.f('Register failed: $errorMessage');
        return left(Failure(errorMessage.trim()));
      } else {
        // Handle other DioErrors or network issues
        lgr.e('Register failed with error: ${err.message}');
        return left(Failure('Register failed: ${err.message}'));
      }
    } catch (err) {
      lgr.e('Register failed with unexpected error: $err');
      return left(Failure('Register failed due to an unexpected error'));
    }
  }

  FutureEitherVoid sendOTPToEmail({required String email}) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.forgotPassword,
      );
      lgr.i('Send OTP request sending to: ${uri.toString()}');
      final response = await _dioClient.post(
        uri.toString(),
        data: {'email': email},
      );
      lgr.w('Send OTP response received: ${response.data}');
      if (response.statusCode == 200) {
        lgr.i('Send OTP success');
        return right(null);
      }

      lgr.f('Send OTP failed');
      return left(Failure('Send OTP failed'));
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 422) {
        // Extract error messages from the response data
        final errorData = err.response!.data['errors'] as Map<String, dynamic>;
        String errorMessage = '';
        errorData.forEach((field, messages) {
          errorMessage += '***${(messages as List).join(' ')}\n\n';
        });

        lgr.f('Register failed: $errorMessage');
        return left(Failure(errorMessage.trim()));
      } else if (err.response != null && err.response!.statusCode == 429) {
        // Extract error messages from the response data
        final errorData = err.response!.data['message'];
        String errorMessage = '';
        errorMessage += '***$errorData\n\n';
        lgr.f('Register failed: $errorMessage');
        return left(Failure(errorMessage.trim()));
      } else {
        // Handle other DioErrors or network issues
        lgr.e('Register failed with error: ${err.message}');
        return left(Failure('Register failed: ${err.message}'));
      }
    } catch (err) {
      lgr.e('Send OTP failed with error: $err');
      return left(Failure('Send OTP failed: $err'));
    }
  }

  FutureEitherVoid verifyOTP({
    required String otp,
    required String email,
  }) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.verifyOtp,
      );

      lgr.i('Verify OTP request sending to: ${uri.toString()}');

      final response = await _dioClient.post(
        uri.toString(),
        data: {'otp': otp, 'email': email},
      );
      lgr.i('Verify OTP response received: ${response.data}');
      if (response.statusCode == 200) {
        lgr.i('Verify OTP success');
        return right(null);
      } else {
        lgr.f('Verify OTP failed');

        return left(Failure('Verify OTP failed'));
      }
    } catch (err) {
      lgr.e('Verify OTP failed with error: $err');
      return left(Failure('Verify OTP failed: $err'));
    }
  }

  FutureEitherVoid resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.resetPassword,
      );
      lgr.i('Password reset request sending to: ${uri.toString()}');
      final response = await _dioClient.post(
        uri.toString(),

        data: {
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': password,
        },
      );
      lgr.i('Password reset response received: ${response.data}');
      if (response.statusCode == 200) {
        lgr.i('Password reset success');
        return right(null);
      }
      lgr.w('Password reset failed');
      return left(Failure('Password reset failed'));
    } catch (err) {
      lgr.e('Password reset failed with error: $err');
      return left(Failure('Password reset failed: $err'));
    }
  }

  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: 'token');
      await _secureStorage.delete(key: 'user');
      _authStateController.value = null;
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<String?> getUser() async {
    return await _secureStorage.read(key: 'user');
  }

  Future<void> saveUser(LoginResponseModel response) async {
    await _secureStorage.write(key: 'token', value: response.token);
    await _secureStorage.write(
      key: 'user',
      value: jsonEncode(response.user?.toJson()),
    );
  }
}
