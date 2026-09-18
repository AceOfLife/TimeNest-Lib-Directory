import 'package:flutter/material.dart';

class AppRadius {
  static const small = Radius.circular(12);
  static const medium = Radius.circular(18);
  static const large = Radius.circular(24);

  static const card = BorderRadius.all(large);

  static const button = BorderRadius.all(
    Radius.circular(16),
  );
}