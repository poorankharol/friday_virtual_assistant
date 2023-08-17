import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:friday_virtual_assistant/core/chat/chat_api.dart';
import 'package:friday_virtual_assistant/model/chat.dart';

class ChatRepository {
  final ChatAPI _chatAPI;

  ChatRepository(this._chatAPI);

  Future<Chat> requestChat(String prompt) async {
    try {
      final res = await _chatAPI.requestChat(prompt);
      final chat = Chat.fromMap(res.data);
      return chat;
    } on DioException catch (errorMessage) {
      log(errorMessage.toString());
      rethrow;
    }
  }
}