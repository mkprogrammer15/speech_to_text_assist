import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/calculator_screen.dart';
import 'package:speech_to_text_my_app/projekt1_screen.dart';
import 'package:speech_to_text_my_app/emails_screen.dart';
import 'package:speech_to_text_my_app/locations_screen.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';
import 'package:speech_to_text_my_app/widgets/menu_button.dart';
import 'package:speech_to_text_my_app/widgets/mic_button.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      routes: {
        '/': (context) => const MyHomePage(),
        LocationsScreen.routeName: (context) => const LocationsScreen(),
        Projekt1Screen.routeName: (context) => const Projekt1Screen(),
        EmailsScreen.routeName: (context) => const EmailsScreen(),
        Calculator.routeName: (context) => const Calculator()
      },
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
  bool isChosenDE = true;
  bool isChosenEN = false;

  final String defaultLocale = Platform.localeName;

  @override
  Widget build(BuildContext context) {
    print(defaultLocale);
    Locale appLocale = Localizations.localeOf(context);
    print('appLocale = $appLocale');
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
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MenuButton(itemName: itemName1, routeName: 'emails', engName: 'Emails', language: 'en_EN'),
              MenuButton(itemName: itemName2, routeName: 'projekt1', engName: 'Project1', language: 'en_EN'),
              MenuButton(itemName: itemName3, routeName: 'locations', engName: 'mk locations', language: 'en_EN'),
              MenuButton(itemName: itemName4, routeName: 'calculator', engName: 'Calculator', language: 'en_EN')
            ],
          ),
        ),
        floatingActionButton: micButton(context, toggleRecording, isListening));
  }
}
