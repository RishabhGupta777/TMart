import 'dart:math';

import 'package:flutter/material.dart';

class TColors{

  static const Color primary=Color(0xFF4b68ff);

  //Text Colors
  static const Color textWhite = Colors.white ;
}


// getRandomColor() => Colors.primaries[Random().nextInt(Colors.primaries.length)];

getRandomColor() => [
  Colors.blueAccent,
  Colors.redAccent,
  Colors.greenAccent,
][Random().nextInt(3)];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;
const Color primary=Color(0xFF4b68ff);