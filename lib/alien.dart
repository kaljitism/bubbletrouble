import 'package:flutter/material.dart';

class Alien extends StatelessWidget {
  final double alienX;
  final double alienY;

  const Alien({super.key, required this.alienX, required this.alienY});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(alienX, alienY),
      child: SizedBox(
        height: 80.0,
        width: 80.0,
        child: Image.asset('assets/alien.png'),
      ),
    );
  }
}
