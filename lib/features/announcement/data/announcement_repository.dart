import 'package:bjp_app/core/constants/api_constants.dart';
import 'package:bjp_app/core/failure.dart';
import 'package:bjp_app/core/type_defs.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/providers.dart';
import '../../../core/utils/utils.dart';
import '../../../dataRepository/global.dart';
import '../domain/announcement.dart';

part 'announcement_repository.g.dart';

@riverpod
AnnouncementRepository announcementRepository(Ref ref) {
  return AnnouncementRepository(
    dioClient: ref.read(dioProvider),
    secureStorage: ref.read(secureStorageProvider),
  );
}

class AnnouncementRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;

  AnnouncementRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  FutureEither<List<Announcement>> getAllAnnouncements() async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getAllAnnouncements,
      );

      //  // final token = await _secureStorage.read(key: 'token');
      lgr.i('uri is: $uri');
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
      lgr.i('code: ${response.statusCode}');
      lgr.i('response is: ${response.data}');

      if (response.statusCode != 200) {
        lgr.w('error: ${response.data}');
        return left(Failure('ঘোষণা গুলি পাওয়া যায়নি'));
      }
      final data = response.data['data'] as List<dynamic>;
      lgr.i('announcements: $data');
      final announcements =
          data
              .map(
                (announcement) =>
                    Announcement.fromMap(announcement as Map<String, dynamic>),
              )
              .toList();

      return right(announcements);
    } catch (err) {
      lgr.e('error happened: $err');
      return left(Failure('ঘোষণা গুলি পাওয়া যায়নি'));
    }
  }

  FutureEither<Announcement> getAnnouncementById({required String id}) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: '${ApiConstants.getAllAnnouncements}/$id',
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

      if (response.statusCode != 200) {
        return left(Failure('ঘোষণা পাওয়া যায়নি'));
      }

      final data = response.data['data'];

      final announcement = Announcement.fromMap(data as Map<String, dynamic>);

      return right(announcement);
    } catch (err) {
      return left(Failure('ঘোষণা পাওয়া যায়নি'));
    }
  }

  FutureEitherVoid createAnnouncement({
    required String annoucement,
    required String divisionId,
  }) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getAllAnnouncements,
      );

       // final token = await _secureStorage.read(key: 'token');
      lgr.i('uri is: $uri');
      final response = await _dioClient.post(
        uri.toString(),
        data: {'content': annoucement, 'division_id': divisionId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );

      lgr.i('code: ${response.statusCode}');
      lgr.i('response: ${response.data}');

      if (response.statusCode != 201) {
        return left(Failure('ঘোষণা তৈরি করা যায়নি'));
      }

      lgr.i('response: ${response.data}');
      return right(null);
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 422) {
        lgr.e('error: ${err.response!.data['errors']}');
        lgr.i('returning left');
        return left(Failure(err.response!.data['errors']));
      }
      return left(Failure(err.response!.data['errors']));
    } catch (err) {
      lgr.f('error: $err');
      return left(Failure('ঘোষণা তৈরি করা যায়নি'));
    }
  }

  // updateAnnouncement

  FutureEitherVoid updateAnnouncement({
    required String id,
    required String announcement,
    required String divisionId,
  }) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: '${ApiConstants.getAllAnnouncements}/$id',
        queryParameters: {'content': announcement, 'division_id': divisionId},
      );

       // final token = await _secureStorage.read(key: 'token');

      final response = await _dioClient.put(
        uri.toString(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );

      if (response.statusCode != 200) {
        return left(Failure('ঘোষণা আপডেট করা যায়নি'));
      }

      return right(null);
    } catch (err) {
      return left(Failure('ঘোষণা আপডেট করা যায়নি'));
    }
  }

  // deleteAnnouncement

  FutureEitherVoid deleteAnnouncement({required String id}) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: '${ApiConstants.getAllAnnouncements}/$id',
      );

       // final token = await _secureStorage.read(key: 'token');

      final response = await _dioClient.delete(
        uri.toString(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );
      lgr.i('response: ${response.data}');
      lgr.i('code: ${response.statusCode}');
      if (response.statusCode != 200) {
        return left(Failure('ঘোষণা মুছে ফেলা যায়নি'));
      }

      return right(null);
    } catch (err) {
      return left(Failure('ঘোষণা মুছে ফেলা যায়নি'));
    }
  }
}
