import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/api/user_otp.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/home_screen%20_madhuwan.dart';
import 'package:multi_club_app/screens/home_screen%20_millenniummams.dart';
import 'package:multi_club_app/screens/home_screen_BRC.dart';
import 'package:multi_club_app/screens/login_screen.dart';

class SplashScreenmillenniumMams extends StatefulWidget {
  const SplashScreenmillenniumMams({Key? key}) : super(key: key);

  @override
  _SplashScreenmillenniumMamsState createState() =>
      _SplashScreenmillenniumMamsState();
}

class _SplashScreenmillenniumMamsState extends State<SplashScreenmillenniumMams>
    with SingleTickerProviderStateMixin {
  String? meberID;
  final _userData = Hive.box('UserData');

  Future<void> accessMemberIdFromHive() async {
    // Open the Hive box
    var box = await Hive.openBox('UserData');

    // Retrieve the user data from Hive
    var userData = box.get('user_data_key');
    var memberId;
    // Access the memberid from the user data
    if (userData != null) {
      memberId = userData['firstname'];
    }
    // Check if memberId is not null before using it
    if (memberId != null) {
      meberID = memberId.toString();
      print('Member ID in slsh Screen: $meberID');
    } else {
      print('Member ID is null');
    }
  }

  @override
  void initState() {
    super.initState();
    accessMemberIdFromHive();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () {
      if (meberID != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const HomeScreenMillenniumMams(),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ));
      }
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
              padding: EdgeInsets.only(top: 86.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/mmmain_logo.png',
                    width: 240,
                    height: 100,
                  ),

                  SizedBox(
                      height: 20), // Add some space between the image and text
                  Text(
                    "The Millennium Mams'",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppThemes
                          .brc_splashtextcolor, // Set the color of the divider
                    ),
                  ),
                  Text(
                    'Founded in 1993',
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
            bottom: 180,
            left: 60,
            right: 60,
            child: Image.asset(
              'assets/images/mm30_years1.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
