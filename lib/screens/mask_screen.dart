import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/text_field_bloc/textfield_bloc.dart';
import 'package:speech_to_text_my_app/utils.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';

class MaskScreen extends StatefulWidget {
  const MaskScreen({Key? key}) : super(key: key);

  static const routeName = 'mask';

  @override
  State<MaskScreen> createState() => _MaskScreenState();
}

class _MaskScreenState extends State<MaskScreen> with VoiceLogic {
  ShakeDetector? detector;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      toggleRecording(context);
    });
    detector!.onPhoneShake;
  }

  @override
  void dispose() {
    detector!.stopListening();
    super.dispose();
  }

  // double? value = 5;
  ValueNotifier<double> timeToCheck = ValueNotifier<double>(1);
  void setTimeForCircularProgressIndicator() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeToCheck.value <= 0) {
        timer.cancel();
      } else {
        timeToCheck.value = timeToCheck.value - 0.1;
        print(timeToCheck.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(42.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    const Text('This is a calculator SCREEN'),
                    const SizedBox(
                      height: 30,
                    ),
                    ValueListenableBuilder<dynamic>(
                      valueListenable: Utils.isConfirmed,
                      builder: (context, dynamic value, child) {
                        if (Utils.isConfirmed.value == false) {
                          askIfAllFieldsAreCorrect();
                          setTimeForCircularProgressIndicator();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: SpeechApi.currentLocaleId == 'de_DE' ? VoiceLogic.textFieldNameDE.length : VoiceLogic.textFieldNameEN.length,
                          itemBuilder: (_, index) {
                            return SizedBox(
                                width: 300,
                                child: TextFormField(
                                  focusNode: VoiceLogic.multiTextFieldModelList[index].focusNode,
                                  controller: VoiceLogic.multiTextFieldModelList[index].controller,
                                  decoration: InputDecoration(
                                    hintText: SpeechApi.currentLocaleId == 'de_DE' ? VoiceLogic.textFieldNameDE[index] : VoiceLogic.textFieldNameEN[index],
                                    labelText: SpeechApi.currentLocaleId == 'de_DE' ? VoiceLogic.textFieldNameDE[index] : VoiceLogic.textFieldNameEN[index],
                                  ),
                                ));
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ValueListenableBuilder(
                      valueListenable: timeToCheck,
                      builder: (context, double value, child) {
                        print(timeToCheck.value);
                        return Visibility(
                          visible: Utils.isFilled,
                          child: CircularProgressIndicator(strokeWidth: 2, value: timeToCheck.value),
                        );
                      },
                    )
                  ],
                )),
          ),
        ),
        floatingActionButton: AvatarGlow(
          animate: VoiceLogic.isListening.value,
          endRadius: 75,
          glowColor: Theme.of(context).primaryColor,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(microseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: () => toggleRecording(context),
            child: Icon(VoiceLogic.isListening.value ? Icons.mic : Icons.mic_none, size: 36),
          ),
        ));
  }
}
