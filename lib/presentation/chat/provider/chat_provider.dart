import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:friday_virtual_assistant/core/chat/chat_api.dart';
import 'package:friday_virtual_assistant/core/chat/chat_repository.dart';
import 'package:friday_virtual_assistant/model/chat.dart';
import 'package:friday_virtual_assistant/provider/dio_provider.dart';

final chatApiProvider = Provider((ref) {
  return ChatAPI(ref.read(dioClientProvider));
});

final movieDetailsRepositoryProvider = Provider((ref) {
  return ChatRepository(ref.read(chatApiProvider));
});

final chatDataProvider = FutureProvider.family<Chat, String>(
  (ref, prompt) {
    return ref.watch(movieDetailsRepositoryProvider).requestChat(prompt);
  },
);
