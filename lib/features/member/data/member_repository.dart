import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/providers.dart';
import '../../../core/type_defs.dart';
import '../../../core/utils/utils.dart';
import '../../../dataRepository/global.dart';
import '../domain/member_model.dart';

part 'member_repository.g.dart';

@riverpod
MemberRepository memberRepository(Ref ref) {
  return MemberRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class MemberRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;

  MemberRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  /// Fetches all members (no filters applied)
  FutureEither<List<MemberModel>> fetchMembers() async {
    return searchMembers(); // Calls searchMembers with no parameters
  }

  /// Fetches a member by unique ID
  FutureEither<List<MemberModel>> fetchMemberById(String id) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getAllMembers,
        queryParameters: {'user_id': id},
      );

      //  // final token = await _secureStorage.read(key: 'token');
      final response = await _dioClient.get(
        uri.toString(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            // 'Authorization': 'Bearer ' + token!,
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> memberList = response.data['data'];
        final List<MemberModel> members =
            memberList
                .map(
                  (member) =>
                      MemberModel.fromMap(member as Map<String, dynamic>),
                )
                .toList();
        return right(members); // Returns a list, typically with one member
      } else {
        return left(Failure('সদস্যদের তথ্য আনতে গিয়ে একটি ত্রুটি ঘটেছে'));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 401) {
        lgr.w(
          '${err.response!.statusCode} ${err.response!.statusMessage}\n${err.response!.data}',
        );
      }
      return left(Failure('You are not authorized to view this content'));
    } catch (err) {
      lgr.e('Error: $err');
      return left(Failure('সদস্যদের তথ্য আনতে গিয়ে একটি ত্রুটি ঘটেছে'));
    }
  }

  /// Fetches a member by unique mobile number
  FutureEither<List<MemberModel>> fetchMemberByMobile(String mobile) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getAllMembers,
        queryParameters: {'phone_number': mobile},
      );

      // final token = await _secureStorage.read(key: 'token');
      final response = await _dioClient.get(
        uri.toString(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> memberList = response.data['data'];
        final List<MemberModel> members =
            memberList
                .map(
                  (member) =>
                      MemberModel.fromMap(member as Map<String, dynamic>),
                )
                .toList();
        return right(members); // Returns a list, typically with one member
      } else {
        return left(Failure('সদস্যদের তথ্য আনতে গিয়ে একটি ত্রুটি ঘটেছে'));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 401) {
        lgr.w(
          '${err.response!.statusCode} ${err.response!.statusMessage}\n${err.response!.data}',
        );
      }
      return left(Failure('You are not authorized to view this content'));
    } catch (err) {
      lgr.e('Error: $err');
      return left(Failure('সদস্যদের তথ্য আনতে গিয়ে একটি ত্রুটি ঘটেছে'));
    }
  }

  /// General search method for combinations of name, division, district, and subdistrict
  FutureEither<List<MemberModel>> searchMembers({
    String? name,
    String? divisionId,
    String? districtId,
    String? subdistrictId,
  }) async {
    try {
      final Map<String, String> queryParams = {};
      if (name != null && name.isNotEmpty) {
        queryParams['name'] = name;
      }
      if (divisionId != null && divisionId.isNotEmpty) {
        queryParams['division_id'] = divisionId;
      }
      if (districtId != null && districtId.isNotEmpty) {
        queryParams['district_id'] = districtId;
      }
      if (subdistrictId != null && subdistrictId.isNotEmpty) {
        queryParams['subdistrict_id'] = subdistrictId;
      }

      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getAllMembers,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      // final token = await _secureStorage.read(key: 'token');
      final response = await _dioClient.get(
        uri.toString(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> memberList = response.data['data'];
        final List<MemberModel> members =
            memberList
                .map(
                  (member) =>
                      MemberModel.fromMap(member as Map<String, dynamic>),
                )
                .toList();
        return right(members);
      } else {
        return left(Failure('সদস্যদের তথ্য আনতে গিয়ে একটি ত্রুটি ঘটেছে'));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 401) {
        lgr.w(
          '${err.response!.statusCode} ${err.response!.statusMessage}\n${err.response!.data}',
        );
      }
      return left(Failure('You are not authorized to view this content'));
    } catch (err) {
      lgr.e('Error: $err');
      return left(Failure('সদস্যদের তথ্য আনতে গিয়ে একটি ত্রুটি ঘটেছে'));
    }
  }
}
