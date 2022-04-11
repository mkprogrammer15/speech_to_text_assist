import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/utils.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';
import 'package:speech_to_text_my_app/widgets/mic_button.dart';
import 'package:substring_highlight/substring_highlight.dart';

class EmailsScreen extends StatefulWidget {
  const EmailsScreen({Key? key}) : super(key: key);

  static const routeName = 'emails';

  @override
  State<EmailsScreen> createState() => _EmailsScreenState();
}

class _EmailsScreenState extends State<EmailsScreen> with VoiceLogic {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(30).copyWith(bottom: 150),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: SubstringHighlight(
                  text: VoiceLogic.text,
                  terms: Command.all,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  textStyleHighlight: const TextStyle(
                    fontSize: 32,
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: micButton(context, toggleRecording, isListening),
    );
  }
}
