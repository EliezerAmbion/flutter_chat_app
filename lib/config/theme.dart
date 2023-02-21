import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade200,
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

ColorScheme colorScheme() {
  return ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
    primary: Colors.black,
    secondary: Colors.teal,
    tertiary: Colors.white,
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
      fontSize: 28,
    ),
    headline2: TextStyle(
      fontFamily: 'MontBold',
      color: Colors.black,
      fontSize: 22,
    ),
    headline3: TextStyle(
      fontFamily: 'MontBold',
      color: Colors.black,
      fontSize: 16,
    ),
    headline4: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black,
      fontSize: 16,
    ),
    headline5: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black,
      fontSize: 15,
    ),
    headline6: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black87,
      fontSize: 14,
    ),

    // body text theme
    bodyText1: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black87,
      fontSize: 12,
    ),
    bodyText2: TextStyle(
      fontFamily: 'MontReg',
      color: Colors.black87,
      fontSize: 10,
    ),
  );
}

// ThemeData darkTheme() {
//   return ThemeData(
//     scaffoldBackgroundColor: Colors.grey.shade900,
//     fontFamily: 'MontReg',
//     appBarTheme: darkModeAppBarTheme(),
//     textTheme: darkModeTextTheme(),
//     colorScheme: darkModeColorScheme(),
//     elevatedButtonTheme: darkModeElevatedButtonTheme(),
//   );
// }

// AppBarTheme darkModeAppBarTheme() {
//   return const AppBarTheme(
//     iconTheme: IconThemeData(color: Colors.white),
//     centerTitle: true,
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//   );
// }

// ColorScheme darkModeColorScheme() {
//   return ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
//     primary: Colors.white,
//     secondary: Colors.teal,
//     tertiary: Colors.tealAccent,
//   );
// }

// ElevatedButtonThemeData darkModeElevatedButtonTheme() {
//   return ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       shadowColor: Colors.white24,
//       elevation: 12,
//       backgroundColor: Colors.teal,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     ),
//   );
// }

// TextTheme darkModeTextTheme() {
//   return const TextTheme(
//     // header text theme
//     headline1: TextStyle(
//       fontFamily: 'MontBold',
//       color: Colors.white,
//       fontSize: 32,
//     ),
//     headline2: TextStyle(
//       fontFamily: 'MontBold',
//       color: Colors.white,
//       fontSize: 24,
//     ),
//     headline3: TextStyle(
//       fontFamily: 'MontBold',
//       color: Colors.white,
//       fontSize: 18,
//     ),
//     headline4: TextStyle(
//       fontFamily: 'MontReg',
//       color: Colors.white,
//       fontSize: 18,
//     ),
//     headline5: TextStyle(
//       fontFamily: 'MontReg',
//       color: Colors.white,
//       fontSize: 16,
//     ),
//     headline6: TextStyle(
//       fontFamily: 'MontReg',
//       color: Colors.white,
//       fontSize: 14,
//     ),

//     // body text theme
//     bodyText1: TextStyle(
//       fontFamily: 'MontReg',
//       color: Colors.white,
//       fontSize: 12,
//     ),
//     bodyText2: TextStyle(
//       fontFamily: 'MontReg',
//       color: Colors.white,
//       fontSize: 10,
//     ),
//   );
// }
