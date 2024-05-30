import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/home_screen%20_madhuwan.dart';
import 'package:multi_club_app/screens/home_screen%20_millenniummams.dart';
import 'package:multi_club_app/screens/home_screen_BRC.dart';
import 'package:multi_club_app/screens/login_screen.dart';
import 'package:multi_club_app/screens/splash_screen_brc.dart';
import 'package:multi_club_app/screens/splash_screen_madhuban.dart';
import 'package:multi_club_app/screens/splash_screen_millenniumMams.dart';
import 'package:multi_club_app/screens/table_booking.dart';

const String appNickname = 'Multi Club App';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox('UserData');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Widget> splashMap = {
    'forcempower': const SplashScreenBRC(),
    'BRC': const SplashScreenBRC(),
    'stardb': const SplashScreenMadhuban(),
    'madhuban': const SplashScreenMadhuban(),
    'milleniumMams': const SplashScreenmillenniumMams(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appNickname,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              primary: AppThemes.brc_helpdesk_text_color),
          useMaterial3: true,
        ),
        // home: const SplashScreenMadhuban());
        // home: const HomeScreenMillenniumMams());
        home: splashMap[Webservice.appNickname]);
  }
}
