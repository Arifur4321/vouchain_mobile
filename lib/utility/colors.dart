import 'package:flutter/material.dart';

const blue = Color.fromRGBO(44, 97, 241, 1);
const lightBlue = Color.fromRGBO(168, 219, 255, 1);
const darkBlue = Color.fromRGBO(45, 46, 131, 1);
const black = Color.fromRGBO(34, 34, 34, 1);
const darkGrey = Color.fromRGBO(128, 128, 128, 1);
const lightGrey = Color.fromRGBO(237, 237, 237, 1);
const red = Color.fromRGBO(231, 54, 45, 1);
const green = Color.fromRGBO(15, 185, 74, 1);
const white = Color.fromRGBO(251, 248, 243, 1);

Color blueOpacity(double i) {
  return Color.fromRGBO(44, 97, 241, i);
}

tableRowColor(int i) {
  if (i % 2 == 1) {
    return Color.fromRGBO(237, 237, 237, 1);
  } else {
    return Colors.white;
  }
}
