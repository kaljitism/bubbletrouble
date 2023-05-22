import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final double playerX;

  const MyPlayer({super.key, required this.playerX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1),
      child: SizedBox(
        height: 100.0,
        width: 100.0,
        child: Image.asset('assets/ufo.png'),
      ),
    );
  }
}
