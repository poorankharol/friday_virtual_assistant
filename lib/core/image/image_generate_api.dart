import 'package:dio/dio.dart';
import 'package:friday_virtual_assistant/constant/app_constants.dart';
import 'package:friday_virtual_assistant/core/network/dio_client.dart';

class ImageGenerateAPI {
  final DioClient _dioClient;

  ImageGenerateAPI(this._dioClient);

  Future<Response> requestImage(String prompt) async {
    try {
      final body = {
        "prompt": prompt,
      };
      final res = await _dioClient.post(AppConstants.openAIImage, data: body);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
