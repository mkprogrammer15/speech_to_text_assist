import 'package:flutter/material.dart';

class Projekt1Screen extends StatelessWidget {
  const Projekt1Screen({Key? key}) : super(key: key);

  static const routeName = 'projekt1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text('This is a Projekt1 SCREEN'), ElevatedButton(onPressed: () {}, child: const Text('Go home'))],
        ),
      ),
    );
  }
}
