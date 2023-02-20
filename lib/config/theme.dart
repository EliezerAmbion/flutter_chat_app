import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    fontFamily: 'MontReg',
    textTheme: textTheme(),
    colorScheme: colorScheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
  );
}

ColorScheme colorScheme() {
  return ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
    primary: Colors.blueGrey.shade900,
    secondary: Colors.blueGrey.shade600,
    tertiary: Colors.teal,
  );
}

ElevatedButtonThemeData elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 12,
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

TextTheme textTheme() {
  return const TextTheme(
    // header text theme
    headline1: TextStyle(
      fontFamily: 'MontBold',
      color: Colors.black,
      fontSize: 32,
    ),
    headline2: TextStyle(
      fontFamily: 'MontBold',
      color: Colors.black,
      fontSize: 24,
    ),
    headline3: TextStyle(
      fontFamily: 'MontBold',
      color: Colors.black,
      fontSize: 18,
    ),
    headline4: TextStyle(
      fontFamily: 'MontBold',
      color: Colors.black,
      fontSize: 16,
    ),
    headline5: TextStyle(
      fontFamily: 'MontBold',
      color: Colors.black,
      fontSize: 14,
    ),
    headline6: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black,
      fontSize: 14,
    ),

    // body text theme
    bodyText1: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black,
      fontSize: 12,
    ),
    bodyText2: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black,
      fontSize: 10,
    ),
  );
}
