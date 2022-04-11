import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/speech_api.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.itemName, required this.routeName, required this.engName, required this.language}) : super(key: key);

  final String itemName;
  final String routeName;
  final String language;
  final String engName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
        print('$itemName pushed!!!');
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
            SpeechApi.currentLocaleId == language ? engName : itemName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
