import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/utils.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:validators/validators.dart';

mixin VoiceLogic<T extends StatefulWidget> on State<T> {
  static var cities = ValueNotifier<List<String>>(['Berlin', 'Aachen', 'München', 'Leipzig', 'Düsseldorf', 'Bonn']);
  // static bool isListening = false;
  static ValueNotifier isListening = ValueNotifier<bool>(false);

  static var text = ValueNotifier<String>('Press the button and start speaking');
  //static String text = 'Press the button and start speaking';
  static String textFieldInput = '';

  static final scrollController = ScrollController();
  static double offset = 0;
  static List<String> textFieldList = [];
  static List<MultiTextFieldModel> multiTextFieldModelList = [];

  static List textFieldNameDE = <String>['name', 'telefon', 'kommentar'];
  static List textFieldNameEN = <String>['name', 'phone', 'comment'];
  String response = "Sind alle Angaben korrekt ?";
  static TextToSpeech tts = TextToSpeech();
  static Timer? timer;
  static ValueNotifier yes = ValueNotifier<bool>(false);

  static void getAllTextFields() {
    for (int i = 0; i < VoiceLogic.textFieldList.length; i++) {
      MultiTextFieldModel textFieldModel = MultiTextFieldModel(
          fieldName: VoiceLogic.textFieldList[i].replaceAll(' ', ''), requestFocus: FocusNode().requestFocus, isActive: false, controller: TextEditingController(), focusNode: FocusNode());
      multiTextFieldModelList.add(textFieldModel);
    }
  }

  Future<void> scrollUpAndDown(ScrollController scrollController, double offset) async {
    scrollController.animateTo(offset, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  void showSnackBarMessages() {
    VoiceLogic.text.value = '';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    ));
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
        if (!isListening && VoiceLogic.isListening.value) {
          Future.delayed(const Duration(seconds: 1), () {
            Utils.scanText(text.value, context);
          });
        }
        VoiceLogic.isListening.value = isListening;
      },
    );
  }

  void askIfAllFieldsAreCorrect() {
    // VoiceLogic.yes.value = true;
    if (Utils.isFilled) {
      Future.delayed(const Duration(seconds: 3));
      VoiceLogic.tts.speak('Sind alle Angaben korrekt?');
      Future.delayed(const Duration(seconds: 3), () {
        toggleRecording(context);
      });
    }
  }
}
