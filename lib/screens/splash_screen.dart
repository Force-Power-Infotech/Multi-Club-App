import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: AppThemes.brc_splashbg),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 86.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logomain.jpg'),
                    radius: 80,
                  ),
                  const SizedBox(
                      height: 20), // Add some space between the image and text
                  Text(
                    'The Bengal Rowing Club',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppThemes
                          .brc_splashtextcolor, // Set the color of the divider
                    ),
                  ),
                  Text(
                    'Established on August 25, 1929',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B213F), // Set the color of the divider
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/clubpicture.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
