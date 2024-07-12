import 'package:flutter/material.dart';

import 'package:roll_dice_app/gradient_container.dart';

const gradientColor = [
  Color.fromARGB(255, 7, 25, 67),
  Color.fromARGB(255, 93, 17, 200),
];

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GradientContainer(gradientColor),
      ),
    ),
  );
}
