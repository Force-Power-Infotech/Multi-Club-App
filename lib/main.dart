import 'package:flutter/material.dart';
import 'package:multi_club_app/screens/login_screen.dart';

const String appNickname = 'Multi Club App';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appNickname,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
