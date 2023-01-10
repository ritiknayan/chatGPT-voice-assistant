import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgpt_assistant/constants/colors.dart';
import 'package:chatgpt_assistant/controllers/api_services.dart';
import 'package:chatgpt_assistant/controllers/tts.dart';
import 'package:chatgpt_assistant/models/chat_model.dart';
import 'package:chatgpt_assistant/widget/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  var text = "Hold mic and start speaking";
  bool isListening = false;

  final List<ChatMessage> messages = [];

  var scrollController = ScrollController();

  scrollMethod() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: kBgColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            await speechToText.stop();

            if (text.isNotEmpty && text != "Hold mic and start speaking") {
              messages.add(
                ChatMessage(text: text, type: ChatMessageType.user),
              );
              var msg = await ApiServices.sendMessage(text);

              msg = msg.trim();

              setState(() {
                messages.add(
                  ChatMessage(text: msg, type: ChatMessageType.bot),
                );
              });

              Future.delayed(
                const Duration(milliseconds: 500),(){
                  TextToSpeech.speak(msg);
                }
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Failed to process. Try again!"),
                ),
              );
            }
          },
          child: CircleAvatar(
            backgroundColor: kBgColor,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_off,
              color: Colors.white,
            ),
          ),
        ),
      
      ),

      appBar: AppBar(
        leading: const Icon(
          Icons.sort_rounded,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: kBgColor,
        elevation: 0.0,
        title: const Text(
          "ChatGPT voice assistant",
          style: TextStyle(fontWeight: FontWeight.w600, color: kTextColor),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                  fontSize: 24,
                  color: isListening ? Colors.black87 : Colors.black54,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: kChatBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var chat = messages[index];
                    return chatBubble(
                      chattext: chat.text,
                      type: chat.type,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "Developed by RitiKNayan",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
