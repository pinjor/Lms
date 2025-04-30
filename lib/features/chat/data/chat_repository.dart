import 'package:bjp_app/features/chat/presentation/domain/chat_list_model.dart';
import 'package:bjp_app/features/chat/presentation/domain/chat_model.dart';
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

part 'chat_repository.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(
    dioClient: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class ChatRepository {
  final Dio _dioClient;
  final FlutterSecureStorage _secureStorage;
  ChatRepository({
    required Dio dioClient,
    required FlutterSecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  FutureEither<List<ChatModel>> fetchChatMessages(String partner_id) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: '${ApiConstants.getAllMessages}/$partner_id',
      );
      lgr.i('fetching chat messages from: ${uri.toString()}');
       // final token = await _secureStorage.read(key: 'token');
      lgr.e('token: $token');
      lgr.i('sending request to fetch chat messages to ${uri.toString()}');
      final response = await _dioClient.get(
        uri.toString(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );
      lgr.i('got response: $response');

      if (response.statusCode == 200) {
        lgr.i('statusCode: 200 : ${response.data}');
        // Access the "data" key, which contains the list of events
        final List<dynamic> chatList = response.data['data'];
        // Map the list to ChatModel objects
        final chatModelList =
            chatList
                .map(
                  (event) => ChatModel.fromMap(event as Map<String, dynamic>),
                )
                .toList();
        lgr.i('got chatModelList: $chatModelList');
        return right(chatModelList);
      } else {
        return left(Failure('চ্যাট বার্তা গুলি পাওয়া যায়নি'));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 401) {
        lgr.w(
          '${err.response!.statusCode} ${err.response!.statusMessage}\n${err.response!.data}',
        );
      }
      return left(Failure('You are not authorized to view this content'));
    } catch (err) {
      lgr.e('Error fetching chat messages: $err');
      return left(Failure('চ্যাট বার্তা গুলি পাওয়া যায়নি'));
    }
  }

  FutureEither<List<ChatList>> fetchChatList() async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.getAllChats,
      );
      lgr.i('fetching chat messages from: ${uri.toString()}');
       // final token = await _secureStorage.read(key: 'token');
      // lgr.e('token: $token');
      lgr.i('sending request to fetch chat messages to ${uri.toString()}');
      final response = await _dioClient.get(
        uri.toString(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );
      lgr.i('got response: $response');

      if (response.statusCode == 200) {
        lgr.i('statusCode: 200 : ${response.data}');
        // Access the "data" key, which contains the list of events
        final List<dynamic> chatList = response.data['data'];
        // Map the list to ChatModel objects
        final chatModelList =
            chatList
                .map(
                  (event) => ChatList.fromJson(event as Map<String, dynamic>),
                )
                .toList();
        lgr.i('got chatModelList: $chatModelList');
        return right(chatModelList);
      } else {
        return left(Failure('চ্যাট বার্তা গুলি পাওয়া যায়নি'));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 401) {
        lgr.w(
          '${err.response!.statusCode} ${err.response!.statusMessage}\n${err.response!.data}',
        );
      }
      return left(Failure('You are not authorized to view this content'));
    } catch (err) {
      lgr.e('Error fetching chat messages: $err');
      return left(Failure('চ্যাট বার্তা গুলি পাওয়া যায়নি'));
    }
  }

  FutureEitherVoid sendMessage(String receiverId, String text) async {
    try {
      final uri = Uri(
        scheme: 'http',
        port: ApiConstants.port,
        host: ApiConstants.baseUrl,
        path: ApiConstants.sendMessages,
      );
       // final token = await _secureStorage.read(key: 'token');
      // lgr.w('got token: $token');
      final result = await _dioClient.post(
        uri.toString(),
        data: {'receiver_id': receiverId, 'message': text},

        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token!,
          },
        ),
      );

      lgr.i('got response: $result');

      if (result.statusCode == 200) {
        lgr.i('statusCode: 200 : ${result.data}');

        return right(null);
      } else if (result.statusCode == 201) {
        lgr.i('statusCode: 201 : ${result.data}');

        return right(null);
      } else {
        lgr.f('statusCode: ${result.statusCode} : ${result.data}');
        return left(Failure('Failed to send message'));
      }
    } catch (err) {
      lgr.e('error: $err');
      return left(Failure('Failed to send message'));
    }
  }
}
