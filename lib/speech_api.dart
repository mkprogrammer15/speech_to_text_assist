import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechApi {
  static final speech = SpeechToText();
  static bool hasSpeech = false;
  static bool logEvents = false;
  static String currentLocaleId = 'de_DE';

  static List<LocaleName> localeNames = [];

  static Future<bool> record({required Function(String text) onResult, required ValueChanged<bool> onListening}) async {
    if (speech.isListening) {
      speech.stop();
      return true;
    }
    final isAvailable = await speech.initialize(
      onStatus: (status) => onListening(speech.isListening),
      onError: (e) => print('Error: $e'),
    );
    if (isAvailable) {
      speech.listen(onResult: (value) => onResult(value.recognizedWords), localeId: currentLocaleId);
    }
    return isAvailable;
  }

  static void logEvent(String eventDescription) {
    if (logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }
}
