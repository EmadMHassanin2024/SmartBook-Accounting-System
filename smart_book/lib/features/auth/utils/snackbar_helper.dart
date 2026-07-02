import 'package:flutter/material.dart';

class SnackbarHelper {

  static void show(
      BuildContext context,
      String message, Color color,
      [int seconds = 3]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: seconds),
      ),
    );
  }

}

