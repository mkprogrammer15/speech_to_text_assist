import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';
import 'package:speech_to_text_my_app/text_field_bloc/textfield_bloc.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  static const routeName = 'calculator';

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> with VoiceLogic {
  ShakeDetector? detector;

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
                    BlocBuilder<TextfieldBloc, TextfieldState>(builder: (context, state) {
                      if (state is GetTextFieldsState) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: state.textFieldList.length,
                          itemBuilder: (_, index) {
                            return SizedBox(
                                width: 300,
                                child: TextFormField(
                                  focusNode: VoiceLogic.multiTextFieldModelList[index].focusNode,
                                  controller: VoiceLogic.multiTextFieldModelList[index].controller,
                                  decoration: InputDecoration(
                                    hintText: state.textFieldList[index],
                                    labelText: state.textFieldList[index],
                                  ),
                                ));
                          },
                        );
                      } else {
                        return const Text('No data yet');
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                VoiceLogic.multiTextFieldModelList.clear();
                                BlocProvider.of<TextfieldBloc>(context).add(GetTextFieldDataEvent());
                              },
                              child: const Text('Textfields1')),
                          ElevatedButton(
                              onPressed: () {
                                VoiceLogic.multiTextFieldModelList.clear();
                                BlocProvider.of<TextfieldBloc>(context).add(GetTextFieldDataEvent2());
                              },
                              child: const Text('Textfields2'))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Go home')),
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
