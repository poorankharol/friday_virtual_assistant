import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:friday_virtual_assistant/core/image/image_generate_api.dart';
import 'package:friday_virtual_assistant/provider/dio_provider.dart';
import '../../../core/image/image_generate_repository.dart';
import '../../../model/image_data.dart';

final imageGenerateApiProvider = Provider((ref) {
  return ImageGenerateAPI(ref.read(dioClientProvider));
});

final movieDetailsRepositoryProvider = Provider((ref) {
  return ImageGenerateRepository(ref.read(imageGenerateApiProvider));
});

final imageGenerateDataProvider = FutureProvider.family<ImageData, String>(
      (ref, prompt) {
    return ref.watch(movieDetailsRepositoryProvider).requestImage(prompt);
  },
);

final todosState = StateProvider<AsyncValue<ImageData>>(
      (ref) => const AsyncValue.loading(),
);

final todosStateLoading = StateProvider<bool>(
      (ref) => false,
);

