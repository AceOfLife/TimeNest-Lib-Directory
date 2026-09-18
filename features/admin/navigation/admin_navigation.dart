import 'package:flutter/material.dart';

class AdminNavigation {
  const AdminNavigation._();

  static Future<T?> push<T>(
    BuildContext context,
    Widget screen,
  ) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  static Future<T?> replace<T>(
    BuildContext context,
    Widget screen,
  ) {
    return Navigator.pushReplacement<T, T>(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  static void pop(
    BuildContext context,
  ) {
    Navigator.pop(context);
  }
}