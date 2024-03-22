import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  textTheme: textTheme,
  // Add other theme properties you need
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  backgroundColor: Colors.black,
  textTheme: textTheme,
  // Add other theme properties you need
);

const TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(fontSize: 36.0),
  titleMedium: TextStyle(fontSize: 30.0),
  titleSmall: TextStyle(fontSize: 24.0),
  bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
);
