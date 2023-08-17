import 'package:dio/dio.dart';
import 'package:friday_virtual_assistant/constant/app_constants.dart';
import 'package:friday_virtual_assistant/core/network/dio_client.dart';

class ChatAPI {
  final DioClient _dioClient;

  ChatAPI(this._dioClient);

  Future<Response> requestChat(String prompt) async {
    try {
      final body = {
        "model": "text-davinci-003",
        "prompt": prompt,
        "max_tokens": 2000,
        "temperature": 0.9,
        "n": 1
      };
      final res = await _dioClient.post(AppConstants.openAIChat, data: body);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
