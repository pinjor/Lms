import 'package:bjp_app/core/constants/api_constants.dart';
import 'package:bjp_app/features/leadership_training/domain/course_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/failure.dart';
import '../../../core/providers/providers.dart';
import '../../../core/type_defs.dart';
import '../../../dataRepository/global.dart';

part 'courses_repository.g.dart';

@riverpod
CoursesRepository coursesRepository(Ref ref) {
  return CoursesRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class CoursesRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;

  CoursesRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  /// Fetches all courses (no filters applied)

  FutureEither<List<CourseModel>> fetchAllCourses() async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getAllCourses,
      );

       // final token = await _secureStorage.read(key: 'token');

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
        final List<dynamic> data = response.data['data'];
        final List<CourseModel> courses =
            data.map((e) => CourseModel.fromJson(e)).toList();
        return right(courses);
      }
      else{
        return left(Failure('Failed to fetch courses'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
