import 'package:friday_virtual_assistant/model/chat.dart';

class ChatState {
  final Chat? chat;
  final bool isLoading;

  ChatState({this.chat, required this.isLoading});

  ChatState copyWith({Chat? chat, required bool isLoading}) {
    return ChatState(chat: chat ?? this.chat, isLoading: this.isLoading);
  }
}
