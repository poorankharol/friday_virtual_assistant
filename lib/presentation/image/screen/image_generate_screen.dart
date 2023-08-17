import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:friday_virtual_assistant/model/image_data.dart';
import 'package:friday_virtual_assistant/presentation/image/widget/image_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../provider/image_generate_provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;

class ImageGenerateScreen extends ConsumerStatefulWidget {
  const ImageGenerateScreen({super.key});

  @override
  ConsumerState<ImageGenerateScreen> createState() =>
      _ImageGenerateScreenState();
}

class _ImageGenerateScreenState extends ConsumerState<ImageGenerateScreen> {
  final speechToText = SpeechToText();
  String imageResult = "";
  String inputText = "";
  late Future<ImageData> chat;
  final TextEditingController inputController = TextEditingController();
  bool isInputEmpty = true;

  @override
  void initState() {
    super.initState();
    initializeSpeechToText();
  }

  void initializeSpeechToText() async {
    await speechToText.initialize();
  }

  void startListeningNow() async {
    FocusScope.of(context).unfocus();
    await speechToText.listen(onResult: onSpeechToTextResult);
    setState(() {});
  }

  void stopListeningNow() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechToTextResult(SpeechRecognitionResult result) {
    var recordedAudioString = result.recognizedWords;
    speechToText.isListening ? null : sendRequest(recordedAudioString);
  }

  void sendRequest(String recordedString) {
    setState(() {
      inputText = recordedString;
    });
  }

  Future<void> _download(String url) async {
    Dio dio = Dio();
    // Get the image name
    final imageName = path.basename(url);
    // Get the document directory path
    final appDir = await pathProvider.getApplicationCacheDirectory();

    // This is the saved image path
    // You can use it to display the saved image later
    final localPath = path.join(appDir.path, imageName);
    final response = await dio.download(url, localPath);

    // Downloading
    // final imageFile = File(localPath);
    // await imageFile.writeAsBytes(response.data.stream);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Image Downloaded")));
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ImageData> imageData = ref.watch(todosState);
    final imageLoading = ref.watch(todosStateLoading);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: imageData.when(
                  data: (data) {
                    imageResult = data.data[0].url;
                    return ImageWidget(
                      data: imageResult,
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  },
                  loading: () {
                    if (imageLoading) {
                      return Center(
                        child: LoadingAnimationWidget.hexagonDots(
                            size: 50, color: Colors.deepPurple),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                imageData.value != null
                    ? FloatingActionButton(
                        onPressed: () async {
                          await _download(imageResult);
                        },
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        mini: false,
                        child: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector(
                            child: const Icon(Icons.mic),
                            onTap: () {
                              speechToText.isListening
                                  ? stopListeningNow()
                                  : startListeningNow();
                            },
                          ),
                          filled: true,
                          isDense: false,
                          //true if reduce size
                          fillColor: Colors.blue.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        controller: inputController,
                        onChanged: (value) {
                          setState(() {
                            final newMessage = value;
                            if (newMessage.isNotEmpty) {
                              //add these lines
                              isInputEmpty = false;
                            } else {
                              isInputEmpty = true;
                            }
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            isInputEmpty = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (inputController.text.isNotEmpty) {
                          try {
                            var text = inputController.text.trim();
                            inputController.clear();
                            ref.read(todosStateLoading.notifier).state = true;
                            final image = await ref
                                .read(imageGenerateDataProvider(text).future);
                            ref.read(todosState.notifier).state =
                                AsyncValue.data(image);
                            ref.read(todosStateLoading.notifier).state = false;
                          } catch (e) {
                            ref.read(todosState.notifier).state =
                                AsyncValue.error(e, StackTrace.current);
                          }
                        }
                      },
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(10),
                        duration: const Duration(milliseconds: 1000),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isInputEmpty
                              ? Colors.grey
                              : Colors.deepPurpleAccent,
                        ),
                        curve: Curves.bounceInOut,
                        child: const Center(
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
