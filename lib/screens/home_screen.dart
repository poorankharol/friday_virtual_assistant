import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:friday_virtual_assistant/api/api_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController inputController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  String recordedAudioString = "";
  bool isLoading = false;
  bool speakFriday = true;
  String modeOpenAI = "chat";
  String imageResult = "";
  String textResult = "";
  final FlutterTts textToSpeech = FlutterTts();

  void initializeSpeechToText() async {
    await speechToText.initialize();
  }

  @override
  void initState() {
    super.initState();
    initializeSpeechToText();
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
    recordedAudioString = result.recognizedWords;
    print("Speech Result:");
    print(recordedAudioString);
    speechToText.isListening ? null : sendRequest(recordedAudioString);
  }

  Future<void> sendRequest(String input) async {
    stopListeningNow();
    if (modeOpenAI == "chat") {
      await ApiService().requestChat(input, modeOpenAI, 2000).then((value) {
        setState(() {
          isLoading = false;
        });
        inputController.clear();
        if (modeOpenAI == "chat") {
          textResult = utf8.decode(value.choices[0].text.toString().codeUnits);
          if (speakFriday) {
            textToSpeech.speak(textResult);
          }
        }
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error:$onError"),
          ),
        );
      });
    } else {
      await ApiService().requestImage(input, modeOpenAI, 2000).then((value) {
        setState(() {
          isLoading = false;
        });
        inputController.clear();
        setState(() {
          imageResult = value.data[0].url;
        });
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error:$onError"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friday Open AI"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                modeOpenAI = "chat";
              });
            },
            color: modeOpenAI == "chat" ? Colors.deepPurpleAccent : Colors.grey,
            icon: const Icon(Icons.chat),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                modeOpenAI = "image";
              });
            },
            color:
                modeOpenAI == "image" ? Colors.deepPurpleAccent : Colors.grey,
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          if (!isLoading) {
            speakFriday = !speakFriday;
          }
          textToSpeech.stop();
        },
        elevation: 2,
        child: speakFriday
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/sound.png"),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/mute.png"),
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    speechToText.isListening
                        ? stopListeningNow()
                        : startListeningNow();
                  },
                  child: speechToText.isListening
                      ? Center(
                          child: LoadingAnimationWidget.beat(
                              color: speechToText.isListening
                                  ? Colors.deepPurple
                                  : isLoading
                                      ? Colors.deepPurple[400]!
                                      : Colors.deepPurple[200]!,
                              size: 250),
                        )
                      : Image.asset(
                          "assets/images/assistant_icon.png",
                          height: 250,
                          width: 250,
                        ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputController,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (inputController.text.isNotEmpty) {
                        sendRequest(inputController.text.toString());
                      }
                    },
                    child: AnimatedContainer(
                      padding: const EdgeInsets.all(10),
                      duration: const Duration(milliseconds: 1000),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurpleAccent,
                      ),
                      curve: Curves.bounceInOut,
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              modeOpenAI == "chat"
                  ? SelectableText(
                      textResult,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  : modeOpenAI == "image" && imageResult.isNotEmpty
                      ? Column(
                          children: [
                            Image.network(imageResult),
                            const SizedBox(
                              height: 14,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // String? downloaded =
                                //     await ImageDownloader.downloadImage(
                                //         imageResult);
                                // if (downloaded != null) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //       const SnackBar(
                                //           content: Text("Image Downloaded")));
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              child: const Text(
                                "Download",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container()
            ],
          ),
        ),
      ),
    );
  }
}
