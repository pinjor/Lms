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
import '../domain/event_model.dart';

part 'event_repository.g.dart';

@riverpod
EventRepository eventRepository(Ref ref) {
  return EventRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class EventRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;
  EventRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  FutureEither<List<EventModel>> fetchEvents() async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getAllEvents,
      );
      lgr.i('fetching events from: ${uri.toString()}');
      //  // final token = await _secureStorage.read(key: 'token');
      // lgr.e('token: $token');
      lgr.i('sending request to fetch events to ${uri.toString()}');
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
      lgr.i('got response: $response');

      if (response.statusCode == 200) {
        lgr.i('statusCode: 200 : ${response.data}');
        // Access the "data" key, which contains the list of events
        final List<dynamic> eventList = response.data['data'];
        // Map the list to EventModel objects
        final eventModelList =
            eventList
                .map(
                  (event) => EventModel.fromMap(event as Map<String, dynamic>),
                )
                .toList();
        lgr.i('got eventModelList: $eventModelList');
        return right(eventModelList);
      } else {
        return left(Failure('ইভেন্ট গুলি পাওয়া যায়নি'));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 401) {
        lgr.w(
          '${err.response!.statusCode} ${err.response!.statusMessage}\n${err.response!.data}',
        );
      }
      return left(Failure('You are not authorized to view this content'));
    } catch (err) {
      lgr.e('Error fetching events: $err');
      return left(Failure('ইভেন্ট গুলি পাওয়া যায়নি'));
    }
  }
}
