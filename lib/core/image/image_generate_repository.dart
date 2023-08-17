import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:friday_virtual_assistant/core/image/image_generate_api.dart';
import 'package:friday_virtual_assistant/model/image_data.dart';

class ImageGenerateRepository {
  final ImageGenerateAPI _chatAPI;

  ImageGenerateRepository(this._chatAPI);

  Future<ImageData> requestImage(String prompt) async {
    try {
      final res = await _chatAPI.requestImage(prompt);
      final chat = ImageData.fromMap(res.data);
      return chat;
    } on DioException catch (errorMessage) {
      log(errorMessage.toString());
      rethrow;
    }
  }
}