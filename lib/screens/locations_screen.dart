import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';
import 'package:speech_to_text_my_app/widgets/mic_button.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({Key? key}) : super(key: key);

  static const routeName = 'locations';

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> with VoiceLogic {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('This is a MK LOCATIONS SCREEN'),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder(
                valueListenable: VoiceLogic.cities,
                builder: (context, value, child) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: VoiceLogic.cities.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                            child: Text(
                          VoiceLogic.cities.value[index],
                          style: const TextStyle(fontSize: 24),
                        ));
                      });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         VoiceLogic.cities.value.sort();
              //       });
              //     },
              //     child: const Text('sort')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('go back'))
            ],
          ),
        ),
        floatingActionButton: micButton(context, toggleRecording, isListening));
  }
}
