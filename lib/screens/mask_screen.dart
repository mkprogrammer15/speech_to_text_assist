import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';

class MaskScreen extends StatefulWidget {
  const MaskScreen({Key? key}) : super(key: key);

  static const routeName = 'mask';

  @override
  State<MaskScreen> createState() => _MaskScreenState();
}

class _MaskScreenState extends State<MaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            SizedBox(
                width: 300,
                child: TextFormField(
                  controller: VoiceLogic.nameController,
                  decoration: const InputDecoration(
                    hintText: 'name',
                    labelText: 'name',
                  ),
                )),
            SizedBox(
                width: 300,
                child: TextFormField(
                  controller: VoiceLogic.phoneController,
                  decoration: const InputDecoration(hintText: 'telefon', labelText: 'telefon'),
                ))
          ],
        ),
      ),
    );
  }
}
