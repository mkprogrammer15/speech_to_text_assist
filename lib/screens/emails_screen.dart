import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
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
  ShakeDetector? detector;
  @override
  void initState() {
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      toggleRecording(context);
    });
    detector!.onPhoneShake;
    super.initState();
  }

  @override
  void dispose() {
    detector!.stopListening();
    super.dispose();
  }

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
                  text: VoiceLogic.text.value,
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
      floatingActionButton:
          //MicroButton(toggleRecording: toggleRecording, isListening: isListening)
          micButton(context, toggleRecording),
    );
  }
}
