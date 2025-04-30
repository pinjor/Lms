import 'package:bjp_app/core/constants/api_constants.dart';
import 'package:bjp_app/features/media/domain/photo_model.dart';
import 'package:bjp_app/features/media/domain/video_model.dart';
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

part 'media_repository.g.dart';

@riverpod
MediaRepository mediaRepository(Ref ref) {
  return MediaRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class MediaRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;

  MediaRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  /// Fetches all Videos

  FutureEither<VideoModel> fetchAllVideos() async {
    try {
      final uri = Uri(
        scheme: 'http',
        host: ApiConstants.baseUrl,
        port: ApiConstants.port,
        path: ApiConstants.getAllVidoes,
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
        final data = response.data['data'];
        final videoModel = VideoModel.fromMap(data);
        return right(videoModel);
      } else {
        return left(Failure('ভিডিও পেতে ব্যর্থ'));
      }
    } catch (err) {
      return left(Failure('ভিডিও পেতে ব্যর্থ'));
    }
  }

  /// Fetches all Photos

  FutureEither<PhotoModel> fetchAllPhotos() async {
    try {
      final uri = Uri(
        scheme: 'http',
        host: ApiConstants.baseUrl,
        port: ApiConstants.port,
        path: ApiConstants.getAllPhotos,
      );
      lgr.i('uri: $uri');
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
      lgr.i('response: ${response.data['data']}');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        lgr.i('data: $data');
        
        final photoModel = PhotoModel.fromMap(data);
        lgr.i('photoModel: $photoModel');
        return right(photoModel);
      } else {
        return left(Failure('ছবি পেতে ব্যর্থ'));
      }
    } catch (err) {
      return left(Failure('ছবি পেতে ব্যর্থ'));
    }
  }
}
