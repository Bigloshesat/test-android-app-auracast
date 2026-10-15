import 'package:flutter/material.dart';

/// Visual language taken from ArtSound APP UI V9.
class ArtTheme {
  static const background = Color(0xFFF3F0EC);
  static const ink = Color(0xFF1A1A1A);
  static const muted = Color(0xFF8D8D92);
  static const magenta = Color(0xFFC4376F);
  static const magentaSoft = Color(0xFFF8E3EC);
  static const card = Color(0xFFFFFFFF);
  static const wash = Color(0xFFE6EEF2);
  static const line = Color(0xFFE4E0DB);
  static const danger = Color(0xFFC62828);
  static const ring = Color(0xFF8FB4D4);
  static const hero = Color(0xFF1B1B1D);
  static const sound = Color(0xFF8FB0C8);

  static const title = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 32,
    height: 1.15,
    fontWeight: FontWeight.w700,
    color: ink,
  );

  static const subtitle = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 16,
    height: 1.3,
    color: muted,
  );

  static const body = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 15,
    height: 1.35,
    color: ink,
  );

  static const button = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}
