import 'package:flutter/material.dart';

import 'homepage.dart';

void main() {
  runApp(const BubbleTrouble());
}

class BubbleTrouble extends StatelessWidget {
  const BubbleTrouble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
