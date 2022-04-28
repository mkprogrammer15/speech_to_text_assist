import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';

class Projekt1Screen extends StatelessWidget {
  const Projekt1Screen({Key? key}) : super(key: key);

  static const routeName = 'projekt1';

  Widget listViewWidget() {
    return ListView(
        controller: VoiceLogic.scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: List.generate(
            100,
            (index) => Container(
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.blue)),
                  child: ListTile(
                    title: Text('$index'),
                  ),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // Container(
          // child: LicensePage(),
          // )
          Column(
        verticalDirection: VerticalDirection.down,
        children: [
          Expanded(child: listViewWidget()),
        ],
      ),
    );
  }
}
