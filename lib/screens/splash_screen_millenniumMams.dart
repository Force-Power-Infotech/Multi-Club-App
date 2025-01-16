import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/home_screen%20_millenniummams.dart';
import 'package:multi_club_app/screens/login_screen.dart';
import 'package:multi_club_app/screens/login_webview%20screen.dart';
import 'package:multi_club_app/bases/api/latestversion.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreenmillenniumMams extends StatefulWidget {
  const SplashScreenmillenniumMams({super.key});

  @override
  _SplashScreenmillenniumMamsState createState() =>
      _SplashScreenmillenniumMamsState();
}

class _SplashScreenmillenniumMamsState extends State<SplashScreenmillenniumMams>
    with SingleTickerProviderStateMixin {
  String? meberID;
  final _userData = Hive.box('UserData');
  late AnimationController _controller;
  late Animation<double> _animation;

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
      print('Member ID in splash Screen: $meberID');
    } else {
      print('Member ID is null');
    }
  }

  Future<bool> checkAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      log('Current version: $currentVersion');
      
      LatestVersionAPI response = await LatestVersionAPI.details();
      if (response.appVersionData == null || response.appVersionData!.isEmpty) {
        return true;
      }

      // Get version data based on platform
      String deviceType = Platform.isAndroid ? "ANDROID" : "IOS";
      AppVersionData? platformVersion = response.appVersionData!
          .firstWhere((element) => element.deviceType == deviceType,
                     orElse: () => AppVersionData());

      if (platformVersion.appVersion != null && 
          currentVersion != platformVersion.appVersion) {
        if (mounted) {
          showUpdateDialog(context, platformVersion);
        }
        return false;
      }
      return true;
    } catch (e) {
      log('Version check error: $e');
      return true;
    }
  }

 void showUpdateDialog(BuildContext context, AppVersionData versionData) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update,
                  size: 50,
                  color: AppThemes.getBackground(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Update Required',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Please update the app to version ${versionData.appVersion} to continue.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (versionData.playStoreLink != null) {
                      final Uri url = Uri.parse(versionData.playStoreLink!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not open the link.')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppThemes.getBackground(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text(
                    'Update Now',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  @override
  void initState() {
    super.initState();
    accessMemberIdFromHive();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      bool isVersionValid = await checkAppVersion();
      if (isVersionValid && mounted) {
      // if (mounted) {
        if (meberID != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => const HomeScreenMillenniumMams(),
          ));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
                  Image.asset(
                    'assets/images/mmmain_logo.png',
                    width: 240,
                    height: 100,
                  ),
                  const SizedBox(
                      height: 20), // Add some space between the image and text
                  const Text(
                    "Millennium Mams'",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppThemes
                          .brc_splashtextcolor, // Set the color of the divider
                    ),
                  ),
                  const Text(
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
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/mm30_years1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
