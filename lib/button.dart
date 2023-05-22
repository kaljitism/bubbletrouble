import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback function;

  const MyButton({super.key, required this.icon, required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: Colors.white,
          width: 70.0,
          height: 50.0,
          child: icon,
        ),
      ),
    );
  }
}
