import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/utils.dart';

mixin VoiceLogic<T extends StatefulWidget> on State<T> {
  static var cities = ValueNotifier<List<String>>(['Berlin', 'Aachen', 'München', 'Leipzig', 'Düsseldorf', 'Bonn']);
  bool isListening = false;
  static String text = 'Press the button and start speaking';
  static String textFieldInput = '';

  static final scrollController = ScrollController();
  static double offset = 0;
  static List<String> textFieldList = [];
  static List<MultiTextFieldModel> multiTextFieldModelList = [];

  static List textFieldNameDE = <String>['name', 'telefon'];
  static List textFieldNameEN = <String>['name', 'phone'];

  static void getAllTextFields(List<String> someApiList) {
    for (int i = 0; i < someApiList.length; i++) {
      MultiTextFieldModel textFieldModel =
          MultiTextFieldModel(fieldName: someApiList[i].replaceAll(' ', ''), requestFocus: FocusNode().requestFocus, isActive: false, controller: TextEditingController(), focusNode: FocusNode());
      multiTextFieldModelList.add(textFieldModel);
    }
  }

  Future<void> scrollUpAndDown(ScrollController scrollController, double offset) async {
    scrollController.animateTo(offset, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  Future toggleRecording(BuildContext context) {
    return SpeechApi.toggleRecording(
      onResult: (text) => setState(() => VoiceLogic.text = text),
      onListening: (isListening) {
        //  setState(() => this.isListening = isListening);
        if (!isListening && this.isListening) {
          Future.delayed(const Duration(seconds: 1), () {
            Utils.scanText(text, context);
          });
        }
        setState(() => this.isListening = isListening);
      },
    );
  }
}
