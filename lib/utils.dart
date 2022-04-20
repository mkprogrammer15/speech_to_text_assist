import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';
import 'package:url_launcher/url_launcher.dart';

class Command {
  static final all = <String>[openDE, goBackDE, sortDE, filterDE, writeDE];

  static const openDE = 'öffne';
  static const goBackDE = 'zurück';
  static const sortDE = 'alphabetisch';
  static const filterDE = 'zeige';
  static const writeDE = 'schreibe';
  static const chooseDE = 'wähle';
  static const tipDE = 'notiere';
  static const scrollDownDE = 'runter';
  static const scrollUpDE = 'hoch';

  static const openEN = 'open';
  static const goBackEN = 'go back';
  static const sortEN = 'sort';
  static const filterEN = 'show';
  static const writeEN = 'note';
  static const chooseEN = 'choose';
  static const tipEN = 'tip';
}

mixin Utils {
  static String newText = '';

  static void scanText(String rawText, BuildContext context) {
    String text = rawText.toLowerCase();

    if (text.contains(Command.scrollDownDE)) {
      VoiceLogic.offset += 300;
      scrollUpAndDown(VoiceLogic.scrollController, VoiceLogic.offset);
    }

    if (text.contains(Command.scrollUpDE)) {
      if (VoiceLogic.offset <= 0) {
        return;
      }
      VoiceLogic.offset -= 300;
      scrollUpAndDown(VoiceLogic.scrollController, VoiceLogic.offset);
    }

    if (text.contains(Command.openDE)) {
      _getTextAfterCommand(text: text, command: Command.openDE);
      checkSlot(context);
    }

    if (text.contains(Command.openEN)) {
      _getTextAfterCommand(text: text, command: Command.openEN);
      checkSlot(context);
    }

    if (text.contains(Command.goBackDE)) {
      checkSlot(context);
    }

    if (text.contains(Command.goBackEN)) {
      checkSlot(context);
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
      final body = _getTextAfterCommand(text: VoiceLogic.text, command: Command.writeDE);
      openEmail(body: body);
    }

    if (text.contains(Command.writeEN)) {
      final body = _getTextAfterCommand(text: VoiceLogic.text, command: Command.writeEN);
      openEmail(body: body);
    }

    if (text.contains(Command.chooseDE)) {
      _getTextAfterCommand(text: text.replaceAll(' ', ''), command: Command.chooseDE);
      checkTextFieldSlot();
    }

    if (text.contains(Command.chooseEN)) {
      _getTextAfterCommand(text: text.replaceAll(' ', ''), command: Command.chooseEN);
      checkTextFieldSlot();
    }

    if (text.contains('vielfach')) {
      final bodyText = _getTextAfterCommand(text: text, command: 'vielfach');
      checkMultiTextFieldSlot(bodyText);
    }

    if (text.contains(Command.tipDE)) {
      singleTextInput(text: text, amountPersons: 'summepersonen', birthday: 'geburtstag', command: Command.tipDE);
    }

    if (text.contains(Command.tipEN)) {
      singleTextInput(birthday: 'birthday', amountPersons: 'amountpersons', text: text, command: Command.tipEN);
    }
  }

  static void singleTextInput({required String birthday, required String amountPersons, required String text, required String command}) {
    VoiceLogic.textFieldInput = '';
    String body = _getTextAfterCommand(text: text, command: command);

    for (int i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      if (VoiceLogic.multiTextFieldModelList[i].focusNode.hasFocus) {
        VoiceLogic.multiTextFieldModelList[i].controller.text = body;
        if (VoiceLogic.multiTextFieldModelList[i].fieldName!.contains('email')) {
          String newBody = body.replaceAll(' ', '');
          String lastChange = newBody.replaceAll('..', '@');
          VoiceLogic.multiTextFieldModelList[i].controller.text = lastChange;
        }
        if (VoiceLogic.multiTextFieldModelList[i].fieldName!.contains(birthday)) {
          String someNewBody = body.replaceAll(' ', '');
          VoiceLogic.multiTextFieldModelList[i].controller.text = someNewBody;
        }
        if (VoiceLogic.multiTextFieldModelList[i].fieldName!.contains('id') || VoiceLogic.multiTextFieldModelList[i].fieldName!.contains(amountPersons)) {
          //
          var number = <String, num>{'eins': 1, 'zwei': 2, 'drei': 3, 'vier': 4, 'fünf': 5, 'sechs': 6, 'sieben': 7, 'acht': 8, 'neun': 9, 'zehn': 10};
          var numberEN = <String, num>{'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10};
          String noSpace = body.replaceAll(' ', '');
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

  static sortLocations() {
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
      newText = text.substring(indexAfter).trim();
      return newText;
    }
  }

  static Future<void> scrollUpAndDown(ScrollController scrollController, double offset) async {
    await scrollController.animateTo(offset, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  static void checkSlot(BuildContext context) {
    const String locationsScreen = 'mk locations';
    const String calculatorDE = 'rechner';
    const String calculatorEN = 'calculator';
    const String projekt1 = 'projekt1';
    const String emails = 'emails';
    const String goBack = 'zurück';
    const String goBackEN = 'go back';

    if (newText == 'e-mails') {
      newText = 'emails';
    }
    switch (newText) {
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
      case goBack:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        break;
      case goBackEN:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        break;

      default:
    }
  }

  static void checkTextFieldSlot() {
    if (newText == 'e-mail') {
      newText = 'email';
    }

    for (int i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      if (VoiceLogic.multiTextFieldModelList[i].fieldName == newText) {
        VoiceLogic.multiTextFieldModelList[i].focusNode.requestFocus();
      }
    }
  }

  static void checkMultiTextFieldSlot(String c) {
    String speech = c.replaceAll(' ', '');

    List spokenList = <String>[];
    List matchIntentsList = <String>[];
    String speechNoCommands = speech;
    List matchIntentsListNoSpaces = <String>[];

    for (int i = 0; i < VoiceLogic.textFieldList.length; i++) {
      final String item = VoiceLogic.textFieldList[i].replaceAll(' ', '');
      matchIntentsListNoSpaces.add(item);
    }

    for (final item in matchIntentsListNoSpaces) {
      if (speechNoCommands.contains(item)) {
        matchIntentsList.add(item);
        speechNoCommands = speechNoCommands.replaceAll(item, '!');
      }
    }
    print(matchIntentsList);
    speechNoCommands = speechNoCommands.replaceFirst('!', '').replaceAll(',', ' ');
    spokenList = speechNoCommands.split('!');

    if (matchIntentsList.isEmpty) {
      return;
    }

    if (spokenList.isEmpty) {
      return;
    }

    var number = <String, num>{'eins': 1, 'zwei': 2, 'drei': 3, 'vier': 4, 'fünf': 5, 'sechs': 6, 'sieben': 7, 'acht': 8, 'neun': 9, 'zehn': 10};
    for (int i = 0; i < spokenList.length; i++) {
      for (final entry in number.entries) {
        if (spokenList[i].toString().contains(entry.key)) {
          spokenList[i].toString().replaceAll(entry.key, entry.value.toString());
        }
      }
    }

    var maap = Map<String, String>.fromIterables(matchIntentsList as List<String>, spokenList as List<String>);

    for (int i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      VoiceLogic.multiTextFieldModelList[i].isActive = false;
    }

    for (int i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      for (final entry in maap.entries) {
        if (VoiceLogic.multiTextFieldModelList[i].fieldName!.contains(entry.key)) {
          VoiceLogic.multiTextFieldModelList[i].controller.text = entry.value;
          VoiceLogic.multiTextFieldModelList[i].isActive = true;
        }
      }
    }

    for (var i = 0; i < VoiceLogic.multiTextFieldModelList.length; i++) {
      if (VoiceLogic.multiTextFieldModelList[i].isActive == true) {
        VoiceLogic.multiTextFieldModelList[i].requestFocus;
      }
    }

    // for (int i = 0; i < MultiTextFieldModel._multiFieldData.length; i++) {
    //   MultiTextFieldModel._multiFieldData[i].isActive = false;
    // }

    // for (int i = 0; i < MultiTextFieldModel._multiFieldData.length; i++) {
    //   for (final entry in maap.entries) {
    //     if (MultiTextFieldModel._multiFieldData[i].fieldName!.contains(entry.key)) {
    //       MultiTextFieldModel._multiFieldData[i].controller.text = entry.value;
    //       MultiTextFieldModel._multiFieldData[i].isActive = true;
    //     }
    //   }
    // }

    // for (var i = 0; i < MultiTextFieldModel._multiFieldData.length; i++) {
    //   if (MultiTextFieldModel._multiFieldData[i].isActive == true) {
    //     MultiTextFieldModel._multiFieldData[i].requestFocus!();
    //   }
    // }
  }

  static Future navigateToPage(String route, BuildContext context) async {
    if (route.trim().isEmpty) {
      return;
    } else {
      print('ROUTEEEEEE: $route');
      await Navigator.pushNamed(context, route);
    }
  }

  static Future goBack(String route, BuildContext context) async {
    if (route.trim().isEmpty) {
      return;
    } else {
      Navigator.pop(context);
    }
  }

  static filterSomething(String letter) {
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
