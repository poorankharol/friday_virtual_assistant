import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:friday_virtual_assistant/core/chat/chat_repository.dart';
import 'package:friday_virtual_assistant/model/chat.dart';
import 'package:friday_virtual_assistant/model/chat_state.dart';

class ChatStateDataNotifier extends StateNotifier<ChatState> {
  ChatStateDataNotifier(this.repository) : super(ChatState(isLoading: false));

  ChatRepository repository;

  // Future<Chat> requestChat(
  //     String input, String mode, int maximumTokens) async {
  //   final data = await repository.requestChat(input, mode, maximumTokens);
  //   return data;
  // }
}
