import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/speech_api.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({required this.itemName, required this.engName, required this.language, required this.onTap, Key? key}) : super(key: key);

  final String itemName;

  final String language;
  final String engName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
