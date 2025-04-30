import 'package:bjp_app/core/type_defs.dart';
import 'package:bjp_app/features/profile/domain/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/utils.dart';
import '../../../dataRepository/global.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class ProfileRepository {
  final Dio _dioClient;

  final FlutterSecureStorage _secureStorage;

  ProfileRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  FutureEither<ProfileModel> fetchUserProfile() async {
    try {
      final url = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getUserProfile,
      );

       // final token = await _secureStorage.read(key: 'token');
      lgr.w('got token: $token');

      final result = await _dioClient.get(
        url.toString(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );

      if (result.statusCode == 200) {
        lgr.i('got response from profile fetching api: ${result.data}');
        final profile = ProfileModel.fromMap(
          result.data['data'] as Map<String, dynamic>,
        );
        lgr.i('profile: ${profile.toJson()}');
        return right(profile);
      } else {
        lgr.f('statusCode: ${result.statusCode} : ${result.data}');
        return left(Failure('Failed to fetch user profile'));
      }
    } catch (err) {
      lgr.e('error: $err');
      return left(Failure('Failed to fetch user profile'));
    }
  }

  FutureEitherVoid updateProfile({
    required String name,
    required String email,
    required String mobile,
    required String divisionId,
    required String districtId,
    required String upazilaId,
  }) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.updateProfile,
      );
       // final token = await _secureStorage.read(key: 'token');
      lgr.w(
        'sending data: name=$name, email=$email, mobile=$mobile, divisionId=$divisionId, districtId=$districtId, upazilaId=$upazilaId',
      );
      final result = await _dioClient.post(
        uri.toString(),

        data: {
          'name': name,
          'email': email,
          'mobile': mobile,
          'division_id': divisionId,
          'district_id': districtId,
          'upazila_id': upazilaId,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            // 'Authorization': 'Bearer ' + token!,
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );
      if (result.statusCode == 200) {
        lgr.i('statusCode: 200 : ${result.data}');
        return right(null);
      } else {
        lgr.f('statusCode: ${result.statusCode} : ${result.data}');
        return left(Failure('Failed to update profile'));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 422) {
        lgr.w(
          '${err.response!.statusCode} ${err.response!.statusMessage}\n${err.response!.data}',
        );

        final errorData = err.response!.data['errors'] as Map<String, dynamic>;
        String errorMessage = '';
        errorData.forEach((field, messages) {
          errorMessage += '***${(messages).join(' ')}\n\n';
        });

        lgr.f('Register failed: $errorMessage');
        return left(Failure(errorMessage.trim(), title: 'ত্রুটি'));
      }
      return left(Failure('Failed to update profile'));
    } catch (err) {
      lgr.e('error: $err');
      return left(Failure('Failed to update profile'));
    }
  }
}
