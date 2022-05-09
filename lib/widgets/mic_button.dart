import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';

Widget micButton(BuildContext context, Function toggleRecording) {
  return AvatarGlow(
    animate: VoiceLogic.isListening.value,
    endRadius: 75,
    glowColor: Theme.of(context).primaryColor,
    duration: const Duration(milliseconds: 2000),
    repeatPauseDuration: const Duration(microseconds: 100),
    repeat: true,
    child: FloatingActionButton(
      onPressed: () => toggleRecording(context),
      child: Icon(VoiceLogic.isListening.value ? Icons.mic : Icons.mic_none, size: 36),
    ),
  );
}
