import 'package:flutter/material.dart';

//TODO: create styles for easy usability across files

class Styles{
  static final String _fontNameDefault = "Muli";

  static final infoSmall = TextStyle(
    fontFamily: "Rale",
    fontSize: 14,
    color: Colors.white
  );
  static final metricReading = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white
  );


  //Hex value helper function
  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}