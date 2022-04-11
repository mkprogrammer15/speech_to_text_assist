import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

Widget micButton(BuildContext context, Function toggleRecording, bool isListening) {
  return AvatarGlow(
    animate: isListening,
    endRadius: 75,
    glowColor: Theme.of(context).primaryColor,
    duration: const Duration(milliseconds: 2000),
    repeatPauseDuration: const Duration(microseconds: 100),
    repeat: true,
    child: FloatingActionButton(
      onPressed: () => toggleRecording(context),
      child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
    ),
  );
}
