import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: Colors.orange,
  scaffoldBackgroundColor: Colors.grey[200],
  textTheme: textTheme,
  cardColor: Colors.grey[300],
  // Add other theme properties you need
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  primaryColor: Colors.deepPurple,
  cardColor: Colors.grey[800],
  textTheme: textTheme,
  scaffoldBackgroundColor: Colors.grey[900],
  // Add other theme properties you need
);

TextTheme textTheme = const TextTheme(
  displayLarge: TextStyle(fontSize: 64.0, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
  displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(fontSize: 20.0),
  titleMedium: TextStyle(fontSize: 18.0),
  titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  bodyLarge: TextStyle(
    fontSize: 14.0,
  ),
  bodyMedium: TextStyle(
    fontSize: 12.0,
  ),
  bodySmall: TextStyle(
    fontSize: 10.0,
  ),
);

extension ThemeExtension on ThemeData {
  Color get shimmerBaseColor =>
      brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[300]!;
  Color get shimmerHightlightColor =>
      brightness == Brightness.dark ? Colors.grey[900]! : Colors.grey[100]!;
  Color get radioPlayerGradient1 => brightness == Brightness.dark
      ? Colors.black.withOpacity(0.9)
      : Colors.white.withOpacity(0.2);
  Color get radioPlayerGradient2 => brightness == Brightness.dark
      ? Colors.black.withOpacity(0.6)
      : Colors.white.withOpacity(0.4);
}
