import 'package:bjp_app/core/constants/api_constants.dart';
import 'package:bjp_app/core/failure.dart';
import 'package:bjp_app/core/type_defs.dart';
import 'package:bjp_app/core/utils/utils.dart';
import 'package:bjp_app/features/home/domain/recent_announcement.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/providers.dart';
import '../../../dataRepository/global.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class HomeRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;

  HomeRepository({Dio? dioClient, FlutterSecureStorage? secureStorage})
    : _dioClient = dioClient ?? Dio(),
      _secureStorage = secureStorage ?? const FlutterSecureStorage();

  FutureEither<RecentAnnouncement> fetchRecentMemberAnnouncement() async {
    try {
      final uri =
          Uri(
            scheme: 'http',
            host: ApiConstants.baseUrl,
            port: ApiConstants.port,
            path: ApiConstants.getMemberRecentNotification,
          ).toString();

       // final token = await _secureStorage.read(key: 'token');
      final response = await _dioClient.get(
        uri,
        options: Options(
          headers: {
            'Accept': 'application/json',
            // 'Authorization': 'Bearer ' + token!,
           'Authorization': 'Bearer ' + token!,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        lgr.i('Fetched Data: $data');
        final recentAnnouncement = RecentAnnouncement.fromJson(data);
        lgr.i('Recent Announcement: $recentAnnouncement');
        return right(recentAnnouncement);
      } else {
        return left(Failure('Failed to fetch announcements'));
      }
    } catch (err) {
      lgr.e('Error fetching recent announcement: $err');
      return left(Failure('Error fetching recent announcement: $err'));
    }
  }
}
