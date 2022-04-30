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

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      toggleRecording(context);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(Utils.newText),
          duration: const Duration(seconds: 7),
        ));
      });
    });
    detector!.onPhoneShake;
    // if (Utils.isFilled) {
    //   Future.delayed(const Duration(seconds: 3)).then((value) => toggleRecording(context).then((value) {
    //         Utils.newText.contains('ja')
    //             ? Utils.isFilled == false
    //             : setState(
    //                 () {},
    //               );
    //       }));
    // }
  }

  @override
  void dispose() {
    detector!.stopListening();
    super.dispose();
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
                    ListView.builder(
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
                    ),
                  ],
                )),
          ),
        ),
        floatingActionButton: AvatarGlow(
          animate: VoiceLogic.isListening,
          endRadius: 75,
          glowColor: Theme.of(context).primaryColor,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(microseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: () => toggleRecording(context),
            child: Icon(VoiceLogic.isListening ? Icons.mic : Icons.mic_none, size: 36),
          ),
        ));
  }
}
