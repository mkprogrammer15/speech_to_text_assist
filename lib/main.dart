import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';
import 'package:speech_to_text_my_app/screens/calculator_screen.dart';
import 'package:speech_to_text_my_app/screens/mask_screen.dart';
import 'package:speech_to_text_my_app/screens/projekt1_screen.dart';
import 'package:speech_to_text_my_app/screens/emails_screen.dart';
import 'package:speech_to_text_my_app/screens/locations_screen.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/text_field_bloc/textfield_bloc.dart';
import 'package:speech_to_text_my_app/text_field_data_remote/text_field_data_source.dart';
import 'package:speech_to_text_my_app/utils.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';
import 'package:speech_to_text_my_app/widgets/menu_button.dart';
import 'package:speech_to_text_my_app/widgets/mic_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TextfieldBloc>(
          create: (context) => TextfieldBloc(textFieldDataSource: TextFieldDataSource()),
        )
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => const MyHomePage(),
          LocationsScreen.routeName: (context) => const LocationsScreen(),
          Projekt1Screen.routeName: (context) => const Projekt1Screen(),
          EmailsScreen.routeName: (context) => const EmailsScreen(),
          Calculator.routeName: (context) => const Calculator(),
          MaskScreen.routeName: (context) => const MaskScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with VoiceLogic {
  final String itemName1 = 'Emails';
  final String itemName2 = 'Projekt1';
  final String itemName3 = 'MK Locations';
  final String itemName4 = 'Rechner';
  final String itemName5 = 'Maske';
  bool isChosenDE = true;
  bool isChosenEN = false;

  final String defaultLocale = Platform.localeName;
  ShakeDetector? detector;

  @override
  void initState() {
    super.initState();
    VoiceLogic.tts.speak('Hi! Was kann ich für dich tun?');
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
        appBar: AppBar(
          title: const Text('Speech to text'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isChosenDE = true;
                    isChosenEN = false;
                    SpeechApi.currentLocaleId = 'de_DE';
                  });
                },
                child: Text(
                  'DE',
                  style: TextStyle(fontWeight: FontWeight.bold, color: isChosenDE == true ? Colors.black : Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                child: Text('EN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isChosenEN == true ? Colors.black : Colors.white,
                    )),
                onTap: () {
                  setState(() {
                    isChosenDE = false;
                    isChosenEN = true;
                    SpeechApi.currentLocaleId = 'en_EN';
                  });
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuButton(
                  itemName: itemName1,
                  engName: 'Emails',
                  language: 'en_EN',
                  onTap: () => Navigator.pushNamed(context, 'emails'),
                ),
                MenuButton(itemName: itemName2, engName: 'Project1', language: 'en_EN', onTap: () => Navigator.pushNamed(context, 'projekt1')),
                MenuButton(itemName: itemName3, engName: 'mk locations', language: 'en_EN', onTap: () => Navigator.pushNamed(context, 'locations')),
                MenuButton(itemName: itemName4, engName: 'Calculator', language: 'en_EN', onTap: () => Navigator.pushNamed(context, 'calculator')),
                MenuButton(
                  itemName: itemName5,
                  engName: 'mask',
                  language: 'en_EN',
                  onTap: () {
                    VoiceLogic.multiTextFieldModelList.clear();
                    if (SpeechApi.currentLocaleId == 'de_DE') {
                      VoiceLogic.textFieldList = VoiceLogic.textFieldNameDE as List<String>;
                      VoiceLogic.getAllTextFields();
                    } else {
                      VoiceLogic.textFieldList = VoiceLogic.textFieldNameEN as List<String>;
                      VoiceLogic.getAllTextFields();
                    }

                    Navigator.pushNamed(context, 'mask');
                  },
                )
              ],
            ),
          ),
        ),
        floatingActionButton:
            //MicroButton(isListening: isListening, toggleRecording: toggleRecording)
            micButton(context, toggleRecording));
  }
}
