import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    // scaffoldBackgroundColor: Colors.grey.shade300,
    fontFamily: 'MontReg',
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    colorScheme: colorScheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

ThemeData darkTheme() {
  return ThemeData();
}

ColorScheme colorScheme() {
  return ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
    primary: Colors.blueGrey.shade900,
    secondary: Colors.teal,
    tertiary: Colors.tealAccent,
  );
}

ElevatedButtonThemeData elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 12,
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
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
      fontFamily: 'MontReg',
      color: Colors.black,
      fontSize: 18,
    ),
    headline5: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black,
      fontSize: 16,
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
