import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Command {
  static final all = <String>[
    openDE,
    goBackDE,
    sortDE,
    filterDE,
    writeDE,
    writeDE,
    chooseDE,
    tipDE,
    scrollDownDE,
    scrollDownEN,
    goToDe,
    openEN,
    goBackEN,
    sortEN,
    filterEN,
    writeEN,
    chooseEN,
    tipEN,
    scrollDownEN,
    scrollUpEN,
    goToEN,
    'setze',
    'enter',
    'zeige alles',
    'show all',
    'ja',
    'nein'
  ];

  static const openDE = 'öffne';
  static const goBackDE = 'zurück';
  static const sortDE = 'alphabetisch';
  static const filterDE = 'zeige';
  static const writeDE = 'schreibe';
  static const chooseDE = 'wähle';
  static const tipDE = 'notiere';
  static const scrollDownDE = 'runter';
  static const scrollUpDE = 'hoch';
  static const goToDe = 'gehe zu';

  static const openEN = 'open';
  static const goBackEN = 'go back';
  static const sortEN = 'sort';
  static const filterEN = 'show';
  static const writeEN = 'note';
  static const chooseEN = 'choose';
  static const tipEN = 'tip';
  static const scrollDownEN = 'scroll down';
  static const scrollUpEN = 'scroll up';
  static const goToEN = 'go to';
}

mixin Utils {
  static String newText = '';
  static bool isFilled = false;
  static ValueNotifier isConfirmed = ValueNotifier<bool>(false);

  static void scanText(String rawText, BuildContext context) {
    // newText = '';
    isFilled = false;
    String text = rawText.toLowerCase();

    if (text.contains(Command.openDE)) {
      final firstAction = _getTextAfterCommand(text: text, command: Command.openDE);
      checkRouteSlot(context);
      if (text.contains('setze')) {
        final secondAction = _getTextAfterCommand(text: firstAction, command: 'setze');
        createTextFields(context, firstAction);
        checkMultiTextFieldSlot(secondAction);
        isFilled = true;
        return;
      }
      if (text.contains(Command.filterDE)) {
        sortLocations();
        //ToDO: geht nicht
      }
    }

    if (text.contains('ja')) {
      VoiceLogic.tts.speak('Alles klar');
      isConfirmed.value = true;
    }

    if (text.contains('nein')) {
      VoiceLogic.tts.speak('Was soll korrigiert werden');
      isConfirmed.value = false;
    }

    if (text.contains(Command.openEN)) {
      final firstAction = _getTextAfterCommand(text: text, command: Command.openEN);
      checkRouteSlot(context);
      if (text.contains('enter')) {
        final secondAction = _getTextAfterCommand(text: firstAction, command: 'enter');
        createTextFields(context, firstAction);
        checkMultiTextFieldSlot(secondAction);
        isFilled = true;
        return;
      }
      if (text.contains(Command.filterEN)) {
        sortLocations();
        //ToDO: geht nicht
      }
    }

    if (text.contains('setze')) {
      final body = _getTextAfterCommand(text: text, command: 'setze');
      checkMultiTextFieldSlot(body);
      isFilled = true;

      return;
    }

    if (text.contains('enter')) {
      final body = _getTextAfterCommand(text: text, command: 'enter');
      checkMultiTextFieldSlot(body);
      isFilled = true;
      return;
    }

    if (text.contains(Command.goToDe)) {
      _getTextAfterCommand(text: text, command: Command.goToDe);
      checkRouteSlot(context);
    }

    if (text.contains(Command.goToEN)) {
      _getTextAfterCommand(text: text, command: Command.goToEN);
      checkRouteSlot(context);
    }

    if (text.contains(Command.scrollDownDE) || text.contains(Command.scrollDownEN)) {
      VoiceLogic.offset += 300;
      scrollUpAndDown(VoiceLogic.scrollController, VoiceLogic.offset);
    }

    if (text.contains(Command.scrollUpDE) || text.contains(Command.scrollUpEN)) {
      if (VoiceLogic.offset <= 0) {
        return;
      }
      VoiceLogic.offset -= 300;
      scrollUpAndDown(VoiceLogic.scrollController, VoiceLogic.offset);
    }

    if (text.startsWith(Command.goBackDE)) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }

    if (text.startsWith(Command.goBackEN)) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }

    if (text.contains(Command.sortDE)) {
      sortLocations();
    }

    if (text.contains(Command.sortEN)) {
      sortLocations();
    }

    if (text.contains(Command.filterDE)) {
      final letter = _getTextAfterCommand(text: text, command: Command.filterDE);
      filterSomething(letter.characters.first);
    }

    if (text.contains(Command.filterEN)) {
      final letter = _getTextAfterCommand(text: text, command: Command.filterEN);
      filterSomething(letter);
    }

    if (text.contains('zeige alles')) {
      VoiceLogic.cities = ValueNotifier<List<String>>(['Berlin', 'Aachen', 'München', 'Leipzig', 'Düsseldorf', 'Bonn']);
    }

    if (text.contains('show all')) {
      VoiceLogic.cities = ValueNotifier<List<String>>(['Berlin', 'Aachen', 'München', 'Leipzig', 'Düsseldorf', 'Bonn']);
    }
    if (text.contains(Command.writeDE)) {
      final body = _getTextAfterCommand(text: VoiceLogic.text.value, command: Command.writeDE);
      openEmail(body: body);
      return;
    }

    if (text.contains(Command.writeEN)) {
      final body = _getTextAfterCommand(text: VoiceLogic.text.value, command: Command.writeEN);
      openEmail(body: body);
      return;
    }

    if (text.contains(Command.chooseDE)) {
      _getTextAfterCommand(text: text.replaceAll(' ', ''), command: Command.chooseDE);
      checkTextFieldSlot();
    }

    if (text.contains(Command.chooseEN)) {
      _getTextAfterCommand(text: text.replaceAll(' ', ''), command: Command.chooseEN);
      checkTextFieldSlot();
    }

    if (text.contains(Command.tipDE)) {
      isFilled = false;
      singleTextInput(
          text: text,
          amountPersons: 'summepersonen',
          birthday: 'geburtstag',
          command: Command.tipDE,
          number: <String, num>{'eins': 1, 'zwei': 2, 'drei': 3, 'vier': 4, 'fünf': 5, 'sechs': 6, 'sieben': 7, 'acht': 8, 'neun': 9, 'zehn': 10});
      isFilled = true;
    }

    if (text.contains(Command.tipEN)) {
      isFilled = false;
      singleTextInput(
          birthday: 'birthday',
          amountPersons: 'amountpersons',
          text: text,
          command: Command.tipEN,
          number: <String, num>{'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10});
      isFilled = true;
    }
    if (text.isEmpty) {
      VoiceLogic.tts.speak('Das habe ich leider nicht verstanden');
    }
  }

  static void singleTextInput({required String birthday, required String amountPersons, required String text, required String command, required Map<String, num> number}) {
    VoiceLogic.textFieldInput = '';
    final body = _getTextAfterCommand(text: text, command: command);

    for (var i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      if (VoiceLogic.multiTextFieldModelList[i].focusNode.hasFocus) {
        VoiceLogic.multiTextFieldModelList[i].controller.text = body;
        if (VoiceLogic.multiTextFieldModelList[i].fieldName!.contains('email')) {
          final newBody = body.replaceAll(' ', '');
          final lastChange = newBody.replaceAll('..', '@');
          VoiceLogic.multiTextFieldModelList[i].controller.text = lastChange;
        }
        if (VoiceLogic.multiTextFieldModelList[i].fieldName!.contains(birthday)) {
          final someNewBody = body.replaceAll(' ', '');
          VoiceLogic.multiTextFieldModelList[i].controller.text = someNewBody;
        }
        if (VoiceLogic.multiTextFieldModelList[i].fieldName!.contains('id') || VoiceLogic.multiTextFieldModelList[i].fieldName!.contains(amountPersons)) {
          final noSpace = body.replaceAll(' ', '');
          for (final item in number.entries) {
            if (noSpace.contains(item.key)) {
              final noWords = noSpace.replaceAll(item.key, item.value.toString());
              VoiceLogic.multiTextFieldModelList[i].controller.text = noWords;
            }
          }
        }
      }
    }
  }

  static void sortLocations() {
    final someList = VoiceLogic.cities;
    someList.value.sort();
    VoiceLogic.cities.value = [...someList.value];
  }

  static String _getTextAfterCommand({
    required String text,
    required String command,
  }) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return 'null';
    } else {
      return newText = text.substring(indexAfter).trim();
    }
  }

  static Future<void> scrollUpAndDown(ScrollController scrollController, double offset) async {
    await scrollController.animateTo(offset, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  static void createTextFields(BuildContext context, String someText) {
    VoiceLogic.multiTextFieldModelList.clear();
    if (SpeechApi.currentLocaleId == 'de_DE') {
      VoiceLogic.textFieldList = VoiceLogic.textFieldNameDE;
      VoiceLogic.getAllTextFields();
    } else {
      VoiceLogic.textFieldList = VoiceLogic.textFieldNameEN;
      VoiceLogic.getAllTextFields();
    }
  }

  static void checkRouteSlot(BuildContext context) {
    const locationsScreen = 'mk locations';
    const calculatorDE = 'rechner';
    const calculatorEN = 'calculator';
    const projekt1 = 'projekt1';
    const emails = 'emails';
    const dashBoard = 'dashboard';
    const maskScreenDE = 'maske';
    const maskScreenEN = 'mask';

    final intents = [locationsScreen, calculatorDE, calculatorEN, projekt1, emails, dashBoard, maskScreenDE, maskScreenEN];
    final matcher = <String>[];

    if (newText == 'e-mails') {
      newText = 'emails';
    }

    for (final item in intents) {
      if (newText.contains(item)) {
        matcher.add(item);
      }
    }

    switch (matcher.first) {
      case locationsScreen:
        Navigator.pushNamed(context, 'locations');
        break;
      case calculatorDE:
        Navigator.pushNamed(context, 'calculator');
        break;
      case calculatorEN:
        Navigator.pushNamed(context, 'calculator');
        break;
      case projekt1:
        Navigator.pushNamed(context, 'projekt1');
        break;
      case emails:
        Navigator.pushNamed(context, 'emails');
        break;
      case dashBoard:
        Navigator.pushNamed(context, '/');
        break;
      case maskScreenDE:
        VoiceLogic.multiTextFieldModelList.clear();
        VoiceLogic.textFieldList = VoiceLogic.textFieldNameDE;
        VoiceLogic.getAllTextFields();
        Navigator.pushNamed(
          context,
          'mask',
        );
        break;

      case maskScreenEN:
        VoiceLogic.multiTextFieldModelList.clear();
        VoiceLogic.textFieldList = VoiceLogic.textFieldNameDE;
        VoiceLogic.getAllTextFields();
        Navigator.pushNamed(context, 'mask');
        break;

      default:
        // VoiceLogic.tts.speak('Das habe ich jetzt nicht verstanden');
        print('test');
    }
  }

  static void checkTextFieldSlot() {
    if (newText == 'e-mail') {
      newText = 'email';
    }

    for (var i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      if (VoiceLogic.multiTextFieldModelList[i].fieldName == newText) {
        VoiceLogic.multiTextFieldModelList[i].focusNode.requestFocus();
      }
    }
  }

  static final dateReg = RegExp('([0-9]{1,2}).{0,1}([a-zA-Z]*)([0-9]{4})');

  static String convertDateField(String dateInput1) {
    var newDateInput = '';
    var convertedDate = '';

    if (dateInput1.contains('.')) {
      newDateInput = dateInput1.replaceAll('.', '').toLowerCase();
    }

    final germanMonths = <String, String>{
      'januar': '.01.',
      'februar': '.02.',
      'märz': '.03.',
      'april': '.04.',
      'mai': '.05.',
      'juni': '.06.',
      'juli': '.07.',
      'august': '.08.',
      'september': '.09.',
      'oktober': '.10.',
      'november': '.11.',
      'dezember': '.12.'
    };

    for (var i = 0; i < germanMonths.entries.length; i++) {
      for (final entry in germanMonths.entries) {
        if (newDateInput.contains(entry.key)) {
          convertedDate = newDateInput.replaceAll(entry.key, entry.value);
          print(convertedDate);
        }
      }
    }
    final strings = convertedDate.split('.');
    strings[0] = strings[0].padLeft(2, '0');
    strings[1] = '.${strings[1]}.';
    final dateString = strings.join();
    return dateString;
  }

  static void checkMultiTextFieldSlot(String c) {
    final speech = c.replaceAll(' ', '');

    List spokenList = <String>[];
    final matchIntentsList = <String>[];
    var speechNoCommands = speech.replaceAll('als', '');

    final matchIntentsListNoSpaces = <String>[];

    for (var i = 0; i < VoiceLogic.textFieldList.length; i++) {
      final item = VoiceLogic.textFieldList[i].replaceAll(' ', '');
      matchIntentsListNoSpaces.add(item);
    }

    for (final item in matchIntentsListNoSpaces) {
      if (speechNoCommands.contains(item)) {
        matchIntentsList.add(item);
      }
      speechNoCommands = speechNoCommands.replaceFirst(item, '!');
    }

    speechNoCommands = speechNoCommands.replaceFirst('!', '').replaceAll(',', ' ');
    spokenList = speechNoCommands.split('!');

    if (matchIntentsList.isEmpty) {
      return;
    }

    if (spokenList.isEmpty) {
      return;
    }

    final number = <String, num>{'eins': 1, 'zwei': 2, 'drei': 3, 'vier': 4, 'fünf': 5, 'sechs': 6, 'sieben': 7, 'acht': 8, 'neun': 9, 'zehn': 10};
    for (var i = 0; i < spokenList.length; i++) {
      for (final entry in number.entries) {
        if (spokenList[i].toString().contains(entry.key)) {
          spokenList[i].toString().replaceAll(entry.key, entry.value.toString());
        }
      }
    }

    final maap = Map<String, String>.fromIterables(matchIntentsList.toSet().toList(), spokenList as List<String>);

    for (var i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      VoiceLogic.multiTextFieldModelList[i].isActive = false;
    }

    for (var i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      for (final entry in maap.entries) {
        if (VoiceLogic.multiTextFieldModelList[i].fieldName!.contains(entry.key)) {
          VoiceLogic.multiTextFieldModelList[i].controller.text = entry.value;
          if (VoiceLogic.multiTextFieldModelList[i].controller.text.contains(dateReg)) {
            final dateStringConverted = convertDateField(entry.value);
            VoiceLogic.multiTextFieldModelList[i].controller.text = dateStringConverted;
          }
          VoiceLogic.multiTextFieldModelList[i].isActive = true;
        }
      }
    }

    for (var i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      if (VoiceLogic.multiTextFieldModelList[i].isActive! == true) {
        VoiceLogic.multiTextFieldModelList[i].requestFocus!;
      }
    }
  }

  static List<String> filterSomething(String letter) {
    final someList = VoiceLogic.cities;
    final newList = ValueNotifier<List<String>>([]);
    for (final item in someList.value) {
      if (item.startsWith(letter.toUpperCase())) {
        newList.value.add(item);
      }
    }
    return VoiceLogic.cities.value = [...newList.value];
  }

  static Future openLink({
    required String url,
  }) async {
    if (url.trim().isEmpty) {
      await _launchUrl('https://google.com');
    } else {
      await _launchUrl('https://$url');
    }
  }

  static Future openEmail({
    required String body,
  }) async {
    final url = 'mailto: ?body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }

  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

class MultiTextFieldModel {
  String? fieldName;
  VoidCallback? requestFocus;
  bool? isActive;
  TextEditingController controller;
  FocusNode focusNode;

  MultiTextFieldModel({required this.fieldName, required this.requestFocus, required this.isActive, required this.controller, required this.focusNode});
}
