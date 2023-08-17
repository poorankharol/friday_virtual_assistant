
import 'package:dio/dio.dart';
import 'package:friday_virtual_assistant/model/chat.dart';
import 'package:friday_virtual_assistant/model/image_data.dart';
import '../constant/api_key.dart';

class ApiService {
  Future<Chat> requestChat(String input, String mode, int maximumTokens) async {
    String openAIURL =
        mode == "chat" ? "v1/completions" : "v1/images/generations";

    final body = mode == "chat"
        ? {
            "model": "text-davinci-003",
            "prompt": input,
            "max_tokens": 2000,
            "temperature": 0.9,
            "n": 1
          }
        : {
            "prompt": input,
          };

    print("$baseUrl$openAIURL");
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $apiKey";
    final response = await dio.post(
      "$baseUrl$openAIURL",
      data: body,
    );
    return Chat.fromMap(response.data);
  }
  Future<ImageData> requestImage(String input, String mode, int maximumTokens) async {
    String openAIURL =
    mode == "chat" ? "v1/completions" : "v1/images/generations";

    final body = mode == "chat"
        ? {
      "model": "text-davinci-003",
      "prompt": input,
      "max_tokens": 2000,
      "temperature": 0.9,
      "n": 1
    }
        : {
      "prompt": input,
    };

    print("$baseUrl$openAIURL");
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $apiKey";
    final response = await dio.post(
      "$baseUrl$openAIURL",
      data: body,
    );
    return ImageData.fromMap(response.data);
  }
}
