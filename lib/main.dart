import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/chat_screen.dart';
import '../screens/chat_screen_v2.dart';
import '../screens/group_info_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/signup_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 23, 30, 34),
          fontFamily: 'MontReg',

          // color scheme
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.blueGrey.shade900,
            secondary: Colors.blueGrey.shade600,
            tertiary: Colors.amber,
          ),

          // text theme
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  color: Colors.grey.shade50,
                ),
                bodyText2: TextStyle(
                  color: Colors.grey.shade500,
                ),
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
        home: const Main(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          SearchScreen.routeName: (context) => SearchScreen(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          ChatScreen.routeName: (context) => ChatScreen(),
          // ChatScreenV2.routeName: (context) => ChatScreenV2(),
          GroupInfoScreen.routeName: (context) => GroupInfoScreen(),
        },
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool _isLogin = true;

  void _toggle() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  void initState() {
    _isLogin = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // if user is logged in
        if (snapshot.hasData) {
          return const HomeScreen();

          // if user is NOT logged in
        } else {
          return _isLogin
              ? LoginScreen(togglePages: _toggle)
              : SignupScreen(togglePages: _toggle);
        }
      },
    );
  }
}
