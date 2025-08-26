import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:multi_club_app/bases/api/apiversion.dart';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:multi_club_app/screens/home_screen%20_madhuwan.dart';
import 'package:multi_club_app/screens/login_screen.dart';

class SplashScreenMadhuban extends StatefulWidget {
  const SplashScreenMadhuban({Key? key}) : super(key: key);

  @override
  _SplashScreenMadhubanState createState() => _SplashScreenMadhubanState();
}

class _SplashScreenMadhubanState extends State<SplashScreenMadhuban>
    with SingleTickerProviderStateMixin {
  String? meberID;
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

  @override
  void initState() {
    super.initState();
    _startSplashLogic();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat();
  }

  Future<void> _startSplashLogic() async {
    await accessMemberIdFromHive();
    // Get current app version
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    debugPrint('DEBUG: Current app version: ' + currentVersion);
    // Determine device type
    final deviceType =
        Theme.of(context).platform == TargetPlatform.iOS ? "IOS" : "ANDROID";
    // Check version from API
    final updateResult = await AppVersionService.checkUpdate(
      deviceType: deviceType,
      currentVersion: currentVersion,
      memberId: meberID ?? 'guest',
    );
    debugPrint('DEBUG: API version: ' + (updateResult.latestVersion ?? 'null'));
    if (updateResult.updateRequired) {
      // Show update dialog and block navigation
      if (mounted) {
        _showUpdateDialog(updateResult);
      }
      return;
    }
    // Wait for splash duration
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    if (meberID != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const HomeScreenMadhuwan(),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ));
    }
  }

  void _showUpdateDialog(UpdateCheckResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Icon(Icons.system_update, color: Colors.deepPurple, size: 32),
              SizedBox(width: 10),
              Text("Update Required",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(result.message ??
                  "A new version of the app is available. Please update to continue."),
              if (result.latestVersion != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text("Latest version: ${result.latestVersion}",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
                final url = isIOS
                    ? 'https://apps.apple.com/in/app/madhuwan/id6505052795'
                    : 'https://play.google.com/store/apps/details?id=com.forcepower.madhuwan&pcampaignid=web_share';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                }
              },
              child: Text("Update Now", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
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
                    'assets/images/madhuwan.jpg',
                    fit: BoxFit.cover,
                    width: 240,
                    height: 100,
                  ),
                  const SizedBox(
                      height: 20), // Add some space between the image and text
                  // const Text(
                  //   'Madhuwan Club',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 16,
                  //     color: AppThemes
                  //         .brc_splashtextcolor, // Set the color of the divider
                  //   ),
                  // ),
                  // const Text(
                  //   'Established on 1980 ',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Color(0xFF4B213F), // Set the color of the divider
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(
                      _animation.value * 3.14159 * 2), // Faster spin
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/madhuwan_logo_main.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
