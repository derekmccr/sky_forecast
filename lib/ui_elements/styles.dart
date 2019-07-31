import 'package:flutter/material.dart';

//general styles for easy reuse
class Styles{
  static final String _fontNameDefault = "Muli";
  static final String _fontNameAccent = "Rale";
  static final Color _textColorDefault = _hexToColor("FFFFFF");

  static final infoSmall = TextStyle(
    fontFamily: _fontNameAccent,
    fontSize: 14,
    color: _textColorDefault
  );
  static final metricReading = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: _textColorDefault
  );

  static final cardInfo = TextStyle(
    fontFamily: _fontNameAccent,
    color: _textColorDefault,
    fontWeight: FontWeight.w600
  );

  static final tileHeader = TextStyle(
      fontFamily: _fontNameDefault,
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: _textColorDefault
  );

  static final tileTrailing = TextStyle(
      fontFamily: _fontNameDefault,
      fontSize: 24.0,
      color: _textColorDefault
  );


  //Hex value helper function
  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}