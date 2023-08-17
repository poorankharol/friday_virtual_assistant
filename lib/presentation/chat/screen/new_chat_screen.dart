import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:friday_virtual_assistant/model/chat.dart';
import 'package:friday_virtual_assistant/model/chat_table.dart';
import 'package:friday_virtual_assistant/presentation/chat/provider/chat_provider.dart';
import 'package:friday_virtual_assistant/presentation/chat/widget/chat_item.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NewChatScreen extends ConsumerStatefulWidget {
  const NewChatScreen({super.key});

  @override
  ConsumerState<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends ConsumerState<NewChatScreen> {
  final speechToText = SpeechToText();
  String textResult = "";
  String inputText = "";
  late Future<Chat> chat;
  final TextEditingController inputController = TextEditingController();
  bool isClicked = false;
  bool isInputEmpty = true;
  List<ChatTable> chatData = [];

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
      isClicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: isClicked
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer(
                        builder: (context, watch, child) {
                          final asyncValue =
                              watch.watch(chatDataProvider(inputText));
                          return asyncValue.when(
                            data: (data) {
                              isClicked = false;
                              chatData
                                  .add(ChatTable(false, data.choices[0].text));
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: chatData.length,
                                  itemBuilder: (itemBuilder, index) {
                                    return ChatItem(
                                        isMe: chatData[index].isMe,
                                        message: chatData[index].message);
                                  });
                            },
                            error: (error, stackTrace) {
                              return Center(
                                child: Text(error.toString()),
                              );
                            },
                            loading: () {
                              return Center(
                                child: LoadingAnimationWidget.hexagonDots(
                                    size: 50, color: Colors.deepPurple),
                              );
                            },
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
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
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (inputController.text.isNotEmpty) {
                      setState(() {
                        isClicked = true;
                        inputText = inputController.text.toString();
                        chatData.add(ChatTable(true, inputText));
                      });
                      inputController.clear();
                    }
                  },
                  child: AnimatedContainer(
                    padding: const EdgeInsets.all(10),
                    duration: const Duration(milliseconds: 1000),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isInputEmpty ? Colors.grey : Colors.deepPurpleAccent,
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
          ),
        ],
      ),
    );
  }
}
