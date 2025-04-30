import 'package:bjp_app/core/constants/api_constants.dart';
import 'package:bjp_app/features/our_discussion/domain/discussion_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/failure.dart';
import '../../../core/providers/providers.dart';
import '../../../core/type_defs.dart';
import '../../../core/utils/utils.dart';
import '../../../dataRepository/global.dart';

part 'discussion_repository.g.dart';

@riverpod
DiscussionRepository discussionRepository(Ref ref) {
  return DiscussionRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class DiscussionRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;

  DiscussionRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  /// Fetches all courses (no filters applied)
  FutureEither<List<DiscussionModel>> fetchAllDiscussions() async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getRecentDiscussion,
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
        final List<dynamic> data = response.data['data'];
        final List<DiscussionModel> discussions =
            data.map((e) => DiscussionModel.fromJson(e)).toList();
        lgr.w('Fetched discussions: $discussions');
        return right(discussions);
      } else {
        return left(Failure('Failed to fetch discussions'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
