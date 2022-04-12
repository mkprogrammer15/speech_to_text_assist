import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/utils.dart';

mixin VoiceLogic<T extends StatefulWidget> on State<T> {
  static var cities = ValueNotifier<List<String>>(['Berlin', 'Aachen', 'München', 'Leipzig', 'Düsseldorf', 'Bonn']);
  bool isListening = false;
  static String text = 'Press the button and start speaking';
  static String textFieldInput = '';

  static final FocusNode emailFocusNode = FocusNode();
  static final FocusNode nameFocusNode = FocusNode();
  static final FocusNode phoneFocusNode = FocusNode();
  static final FocusNode idFocusNode = FocusNode();
  static final FocusNode birthDayFocusNode = FocusNode();
  static final FocusNode amountPersonsFocusNode = FocusNode();
  static final FocusNode addressFocusNode = FocusNode();

  static final emailController = TextEditingController();
  static final nameController = TextEditingController();
  static final amountController = TextEditingController();
  static final phoneController = TextEditingController();
  static final idController = TextEditingController();
  static final birthDayController = TextEditingController();
  static final addressController = TextEditingController();

  static final scrollController = ScrollController();
  static double offset = 0;

  Future<void> scrollUpAndDown(ScrollController scrollController, double offset) async {
    scrollController.animateTo(offset, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  Future toggleRecording(BuildContext context) => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => VoiceLogic.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(const Duration(seconds: 1), () {
              Utils.scanText(text, context);
            });
          }
        },
      );
}
