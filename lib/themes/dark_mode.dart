import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900, // primary color of app
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade700,
    primary: Colors.grey.shade900,
    secondary: const Color.fromARGB(255, 57, 57, 57),
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
  ),
);
