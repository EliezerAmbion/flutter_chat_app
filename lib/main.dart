import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../screens/auth_screens.dart';

import '../screens/chat_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade400,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blueGrey.shade900,
          secondary: Colors.grey.shade900,
          tertiary: Colors.blue,
        ),

        // ElevatedButton Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
