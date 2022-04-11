import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text_my_app/calculator_screen.dart';
import 'package:speech_to_text_my_app/projekt1_screen.dart';
import 'package:speech_to_text_my_app/emails_screen.dart';
import 'package:speech_to_text_my_app/locations_screen.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';

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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'emails');
                print('$itemName1 pushed!!!');
              },
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(width: 2, color: Colors.blue),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                  child: Text(
                    SpeechApi.currentLocaleId == 'en_EN' ? 'Emails' : itemName1,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'projekt1'),
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(width: 2, color: Colors.blue),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                    child: Text(
                  SpeechApi.currentLocaleId == 'en_EN' ? 'Project1' : itemName2,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
              ),
            ),
            GestureDetector(
              onTap: () => {Navigator.pushNamed(context, 'locations'), print('$itemName3 pushed!!!')},
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(width: 2, color: Colors.blue),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    SpeechApi.currentLocaleId == 'en_EN' ? 'mk locations' : itemName3,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'calculator'),
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(width: 2, color: Colors.blue),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                    child: Text(
                  SpeechApi.currentLocaleId == 'en_EN' ? 'Calculator' : itemName4,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
              ),
            ),
          ],
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
      ),
    );
  }
}
