import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/utils.dart';
import 'package:text_to_speech/text_to_speech.dart';

import 'utils.dart';

mixin VoiceLogic<T extends StatefulWidget> on State<T> {
  static ValueNotifier<List<String>> cities = ValueNotifier<List<String>>(['Berlin', 'Aachen', 'München', 'Leipzig', 'Düsseldorf', 'Bonn']);
  // static bool isListening = false;
  static ValueNotifier<bool> isListening = ValueNotifier<bool>(false);

  static ValueNotifier<String> text = ValueNotifier<String>('Press the button and start speaking');
  //static String text = 'Press the button and start speaking';
  static String textFieldInput = '';

  static final scrollController = ScrollController();
  static double offset = 0;
  static List<String> textFieldList = [];
  static List<MultiTextFieldModel> multiTextFieldModelList = [];

  static List<String> textFieldNameDE = ['name', 'telefon', 'kommentar', 'datum'];
  static List<String> textFieldNameEN = ['name', 'phone', 'comment', 'date'];
  String response = 'Sind alle Angaben korrekt ?';
  static TextToSpeech tts = TextToSpeech();
  static Timer? timer;
  static ValueNotifier yes = ValueNotifier<bool>(false);
  static ValueNotifier<double?> durationForUserCheckFields = ValueNotifier<double?>(5);
  static ValueNotifier<double> timeToCheck = ValueNotifier<double>(1);

  static void getAllTextFields() {
    for (var i = 0; i < VoiceLogic.textFieldList.length; i++) {
      final textFieldModel = MultiTextFieldModel(
          fieldName: VoiceLogic.textFieldList[i].replaceAll(' ', ''), requestFocus: FocusNode().requestFocus, isActive: false, controller: TextEditingController(), focusNode: FocusNode());
      multiTextFieldModelList.add(textFieldModel);
    }
  }

  Future<void> scrollUpAndDown(ScrollController scrollController, double offset) async {
    await scrollController.animateTo(offset, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  void showSnackBarMessages() {
    VoiceLogic.text.value = '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ValueListenableBuilder(
          valueListenable: VoiceLogic.text,
          builder: (context, value, child) => Text(
            VoiceLogic.text.value,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        duration: const Duration(seconds: 7),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
      ),
    );
  }

  Future toggleRecording(BuildContext context) {
    showSnackBarMessages();
    return SpeechApi.record(
      //  onResult: (text) => setState(() => VoiceLogic.text.value = text),
      onResult: (text) => VoiceLogic.text.value = text,
      onListening: (isListening) {
        if (isListening == false) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        if (!isListening && (VoiceLogic.isListening.value == true)) {
          Future.delayed(const Duration(seconds: 1), () {
            Utils.scanText(text.value, context);
          });
        }
        VoiceLogic.isListening.value = isListening;
      },
    );
  }

  static void setTimeForCircularProgressIndicator() {
    timeToCheck.value = 1;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeToCheck.value <= 0) {
        timer.cancel();
      } else {
        timeToCheck.value = timeToCheck.value - 0.1;
      }
    });
  }

  Future<void> askIfAllFieldsAreCorrect() async {
    if (Utils.isFilled) {
      await Future<dynamic>.delayed(const Duration(seconds: 3));
      await VoiceLogic.tts.speak('Sind alle Angaben korrekt?');
      setTimeForCircularProgressIndicator();
      await Future.delayed(const Duration(seconds: 5), () async {
        await toggleRecording(context);
      });
      await Future<dynamic>.delayed(const Duration(seconds: 6));

      if (VoiceLogic.text.value.contains('ja')) {
        await askWhatToDoNext();
        return;
      }
      do {
        await Future.delayed(const Duration(seconds: 5), () async {
          await toggleRecording(context);
        });
        await Future<dynamic>.delayed(const Duration(seconds: 7));
        await VoiceLogic.tts.speak('Sind alle Angaben korrekt?');
        setTimeForCircularProgressIndicator();
        await Future.delayed(const Duration(seconds: 5), () async {
          await toggleRecording(context);
        });
        await Future<dynamic>.delayed(const Duration(seconds: 8));
      } while (!VoiceLogic.text.value.contains('ja') || VoiceLogic.text.value.isEmpty);
      await askWhatToDoNext();
    }
  }

  Future<void> askWhatToDoNext() async {
    await Future<dynamic>.delayed(const Duration(seconds: 3));
    await VoiceLogic.tts.speak('Was möchten Sie als nächstes tun?');
    await Future.delayed(const Duration(seconds: 4), () async {
      await toggleRecording(context);
      return;
    });
  }
}
