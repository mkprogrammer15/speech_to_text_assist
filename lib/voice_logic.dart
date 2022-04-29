import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/utils.dart';

mixin VoiceLogic<T extends StatefulWidget> on State<T> {
  static var cities = ValueNotifier<List<String>>(['Berlin', 'Aachen', 'München', 'Leipzig', 'Düsseldorf', 'Bonn']);
  static bool isListening = false;

  static var text = ValueNotifier<String>('Press the button and start speaking');
  //static String text = 'Press the button and start speaking';
  static String textFieldInput = '';

  static final scrollController = ScrollController();
  static double offset = 0;
  static List<String> textFieldList = [];
  static List<MultiTextFieldModel> multiTextFieldModelList = [];

  static List textFieldNameDE = <String>['name', 'telefon', 'kommentar'];
  static List textFieldNameEN = <String>['name', 'phone', 'comment'];

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

  Future toggleRecording(BuildContext context) {
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
    return SpeechApi.record(
      onResult: (text) => setState(() => VoiceLogic.text.value = text),
      onListening: (isListening) {
        // setState(() => this.isListening = isListening);
        if (!isListening && VoiceLogic.isListening) {
          //&& this.isListening
          Future.delayed(const Duration(seconds: 1), () {
            Utils.scanText(text.value, context);
          });
        }
        setState(() => VoiceLogic.isListening = isListening);
      },
    );
  }
}
