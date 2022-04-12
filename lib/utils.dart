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
      filterSomething(letter);
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
      _getTextAfterCommand(text: text, command: Command.chooseDE);
      checkTextFieldSlot();
    }

    if (text.contains(Command.chooseEN)) {
      _getTextAfterCommand(text: text, command: Command.chooseEN);
      checkTextFieldSlot();
    }

    if (text.contains('multi')) {
      final bodyText = _getTextAfterCommand(text: text, command: 'multi');
      checkMultiTextFieldSlot(bodyText);
    }

    if (text.contains(Command.tipDE)) {
      VoiceLogic.textFieldInput = '';
      String body = _getTextAfterCommand(text: text, command: Command.tipDE);

      if (VoiceLogic.nameFocusNode.hasFocus) {
        VoiceLogic.nameController.text = body;
      }
      if (VoiceLogic.emailFocusNode.hasFocus) {
        String newBody = body.replaceAll(' ', '');
        String lastChange = newBody.replaceAll('..', '@');
        VoiceLogic.emailController.text = lastChange;
      }
      if (VoiceLogic.phoneFocusNode.hasFocus) {
        VoiceLogic.phoneController.text = body;
      }
      if (VoiceLogic.addressFocusNode.hasFocus) {
        VoiceLogic.addressController.text = body;
      }
      if (VoiceLogic.amountPersonsFocusNode.hasFocus) {
        VoiceLogic.amountController.text = body;
      }
      if (VoiceLogic.idFocusNode.hasFocus) {
        VoiceLogic.idController.text = body;
      }
      if (VoiceLogic.birthDayFocusNode.hasFocus) {
        String someNewBody = body.replaceAll(' ', '');
        VoiceLogic.birthDayController.text = someNewBody;
      }
    }

    if (text.contains(Command.tipEN)) {
      VoiceLogic.textFieldInput = '';
      String body = _getTextAfterCommand(text: text, command: Command.tipEN);

      if (VoiceLogic.nameFocusNode.hasFocus) {
        VoiceLogic.nameController.text = body;
      }
      if (VoiceLogic.emailFocusNode.hasFocus) {
        String newBody = body.replaceAll(' ', '');
        String lastChange = newBody.replaceAll('..', '@');
        VoiceLogic.emailController.text = lastChange;
      }
      if (VoiceLogic.phoneFocusNode.hasFocus) {
        VoiceLogic.phoneController.text = body;
      }
      if (VoiceLogic.addressFocusNode.hasFocus) {
        VoiceLogic.addressController.text = body;
      }
      if (VoiceLogic.amountPersonsFocusNode.hasFocus) {
        VoiceLogic.amountController.text = body;
      }
      if (VoiceLogic.idFocusNode.hasFocus) {
        VoiceLogic.idController.text = body;
      }
      if (VoiceLogic.birthDayFocusNode.hasFocus) {
        String someNewBody = body.replaceAll(' ', '');
        final lastChange = someNewBody.replaceAll('point', '.');
        VoiceLogic.birthDayController.text = lastChange;
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
        print('Öffne emails');
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
    const String email = 'email';
    const String name = 'name';
    const String amountPersonsDE = 'summe personen';
    const String amountPersonsEN = 'sum persons';
    const String phoneNumberDE = 'telefon';
    const String phoneNumberEN = 'phone';
    const String id = 'id';
    const String birthDateDE = 'geburtstag';
    const String birthDateEN = 'birthday';
    const String addressDE = 'adresse';
    const String addressEN = 'address';

    if (newText == 'e-mail') {
      newText = 'email';
    }

    switch (newText) {
      case email:
        VoiceLogic.emailFocusNode.requestFocus();
        break;
      case name:
        VoiceLogic.nameFocusNode.requestFocus();
        break;
      case amountPersonsDE:
        VoiceLogic.amountPersonsFocusNode.requestFocus();
        break;
      case amountPersonsEN:
        VoiceLogic.amountPersonsFocusNode.requestFocus();
        break;
      case phoneNumberDE:
        VoiceLogic.phoneFocusNode.requestFocus();
        break;
      case phoneNumberEN:
        VoiceLogic.phoneFocusNode.requestFocus();
        break;
      case id:
        VoiceLogic.idFocusNode.requestFocus();
        break;
      case birthDateDE:
        VoiceLogic.birthDayFocusNode.requestFocus();
        break;
      case birthDateEN:
        VoiceLogic.birthDayFocusNode.requestFocus();
        break;
      case addressDE:
        VoiceLogic.addressFocusNode.requestFocus();
        break;
      case addressEN:
        VoiceLogic.addressFocusNode.requestFocus();
        break;
      default:
    }
  }

  static void checkMultiTextFieldSlot(String c) {
    const String email = 'e-mail';
    const String name = 'name';
    const String amountPersonsDE = 'summe personen';
    const String amountPersonsEN = 'sum persons';
    const String phoneNumberDE = 'telefon';
    const String phoneNumberEN = 'phone';
    const String id = 'id';
    const String birthDateDE = 'geburtstag';
    const String birthDateEN = 'birthday';
    const String addressDE = 'adresse';
    const String addressEN = 'address';

    List<String> keyWords = [email, name, amountPersonsDE, amountPersonsEN, phoneNumberDE, phoneNumberEN, id, birthDateDE, birthDateEN, addressDE, addressEN];

    String speech = c.replaceAll(' ', '');

    List spokenList = <String>[];
    final matchIntentsList = <String>[];
    String speechNoCommands = speech;

    for (final item in keyWords) {
      if (speechNoCommands.contains(item)) {
        matchIntentsList.add(item);
        speechNoCommands = speechNoCommands.replaceAll(item, '!');
      }
    }
    speechNoCommands = speechNoCommands.replaceFirst('!', '').replaceAll(',', ' ');
    spokenList = speechNoCommands.split('!');

    var maap = Map<String, String>.fromIterables(matchIntentsList, spokenList as List<String>);

    for (int i = 0; i < MultiTextFieldModel._multiFieldData.length; i++) {
      MultiTextFieldModel._multiFieldData[i].isActive = false;
    }

    for (int i = 0; i < MultiTextFieldModel._multiFieldData.length; i++) {
      for (final entry in maap.entries) {
        if (MultiTextFieldModel._multiFieldData[i].fieldName!.contains(entry.key)) {
          MultiTextFieldModel._multiFieldData[i].controller.text = entry.value;
          MultiTextFieldModel._multiFieldData[i].isActive = true;
        }
      }
    }

    for (var i = 0; i < MultiTextFieldModel._multiFieldData.length; i++) {
      if (MultiTextFieldModel._multiFieldData[i].isActive == true) {
        MultiTextFieldModel._multiFieldData[i].requestFocus!();
      }
    }
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

  MultiTextFieldModel({required this.fieldName, required this.requestFocus, required this.isActive, required this.controller});

  static List<MultiTextFieldModel> _multiFieldData = [
    MultiTextFieldModel(fieldName: 'e-mail', requestFocus: VoiceLogic.emailFocusNode.requestFocus, isActive: false, controller: VoiceLogic.emailController),
    MultiTextFieldModel(fieldName: 'name', requestFocus: VoiceLogic.nameFocusNode.requestFocus, isActive: false, controller: VoiceLogic.nameController),
    MultiTextFieldModel(fieldName: 'summe personen', requestFocus: VoiceLogic.amountPersonsFocusNode.requestFocus, isActive: false, controller: VoiceLogic.amountController),
    MultiTextFieldModel(fieldName: 'telefon', requestFocus: VoiceLogic.phoneFocusNode.requestFocus, isActive: false, controller: VoiceLogic.phoneController),
    MultiTextFieldModel(fieldName: 'id', requestFocus: VoiceLogic.idFocusNode.requestFocus, isActive: false, controller: VoiceLogic.idController),
    MultiTextFieldModel(fieldName: 'geburtstag', requestFocus: VoiceLogic.birthDayFocusNode.requestFocus, isActive: false, controller: VoiceLogic.birthDayController),
    MultiTextFieldModel(fieldName: 'adresse', requestFocus: VoiceLogic.addressFocusNode.requestFocus, isActive: false, controller: VoiceLogic.addressController),
  ];

  static List<MultiTextFieldModel> getList() {
    return _multiFieldData;
  }
}
