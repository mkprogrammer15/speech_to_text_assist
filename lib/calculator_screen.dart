import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text_my_app/bloc/textfield_bloc.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  static const routeName = 'calculator';

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> with VoiceLogic {
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
                    )
                  ],
                )),
          ),
        ),
        floatingActionButton: AvatarGlow(
          animate: isListening,
          endRadius: 75,
          glowColor: Theme.of(context).primaryColor,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(microseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: () => toggleRecording(context),
            child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
          ),
        ));
  }
}

// SizedBox(
//   width: 300,
//   child: TextFormField(
//     focusNode: VoiceLogic.emailFocusNode,
//     controller: VoiceLogic.emailController,
//     decoration: InputDecoration(
//       hintText: 'email@example.com',
//       labelText: 'your email',
//
//     keyboardType: TextInputType.emailAddress,
//     validator: (value) => !EmailValidator.validate(VoiceLogic.emailController.text) ? 'Invalid Email' : null,
//   ),
// ),
// SizedBox(
//   width: 300,
//   child: TextFormField(
//     focusNode: VoiceLogic.nameFocusNode,
//     controller: VoiceLogic.nameController,
//     decoration: InputDecoration(
//       hintText: 'name',
//       labelText: 'name',
//     ),
//     keyboardType: TextInputType.name,
//   ),
// ),
// SizedBox(
//   width: 300,
//   child: TextFormField(
//     focusNode: VoiceLogic.amountPersonsFocusNode,
//     controller: VoiceLogic.amountController,
//     decoration: InputDecoration(
//       hintText: 'How many persons?',
//       labelText: 'Amount of persons',
//     ),
//     keyboardType: TextInputType.number,
//   ),
// ),
// SizedBox(
//   width: 300,
//   child: TextFormField(
//     focusNode: VoiceLogic.phoneFocusNode,
//     controller: VoiceLogic.phoneController,
//     decoration: InputDecoration(
//       hintText: 'your phone number',
//       labelText: 'phone number',
//     ),
//     keyboardType: TextInputType.phone,
//   ),
// ),
// SizedBox(
//   width: 300,
//   child: TextFormField(
//     focusNode: VoiceLogic.idFocusNode,
//     controller: VoiceLogic.idController,
//     decoration: InputDecoration(
//       hintText: 'Your ID',
//       labelText: 'ID',
//     ),
//     keyboardType: TextInputType.text,
//   ),
// ),
// SizedBox(
//   width: 300,
//   child: TextFormField(
//     focusNode: VoiceLogic.birthDayFocusNode,
//     controller: VoiceLogic.birthDayController,
//     decoration: InputDecoration(
//       hintText: 'Choose your birthday',
//       labelText: 'Date of Birth',
//     ),
//     keyboardType: TextInputType.datetime,
//   ),
// ),
// SizedBox(
//   width: 300,
//   child: TextFormField(
//     focusNode: VoiceLogic.addressFocusNode,
//     controller: VoiceLogic.addressController,
//     decoration: InputDecoration(
//       hintText: 'Your address',
//       labelText: 'address',
//     ),
//     keyboardType: TextInputType.emailAddress,
//   ),
// ),
