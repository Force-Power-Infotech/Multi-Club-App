import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/api/user_otp.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/home_screen%20_madhuwan.dart';
import 'package:multi_club_app/screens/home_screen_BRC.dart'; // Import your themes file

class OTPScreen extends StatefulWidget {
  final String username;
  const OTPScreen({super.key, required this.username});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // otp: TextEditingController
  bool isLoading = false;
//refrence the box
  final _userData = Hive.box('UserData');

  final otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OTP',
          style: TextStyle(color: AppThemes.brc_textcolor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppThemes.brc_textcolor),
          onPressed: () {
            // Navigate to the previous screen
            Navigator.pop(context);
          },
        ),
        backgroundColor: Webservice.appNickname == 'forcempower'
            ? AppThemes.getBackground()
            : AppThemes
                .getBackground(), // Use custom primary color from light theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Input Text Field: OTP
            TextField(
              controller: otp,
              decoration: const InputDecoration(
                // hint text
                hintText: 'Enter OTP',
                // underline border
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            // Spacer
            const Spacer(),
            // ElevatedButton: Icon: Arrow Right
            ElevatedButton(
              onPressed: () async {
                // check if the input is valid
                setState(() {
                  isLoading =
                      true; // Set isLoading to true when button is pressed
                });
                UserOtpAPI user =
                    await UserOtpAPI.login(widget.username, otp.text);
                setState(() {
                  isLoading =
                      false; // Set isLoading to false after data is fetched
                });
                if (user.processStatus == "YES") {
                  // Navigate to the Home screen
                  // setUserData();
                  if (Webservice.appNickname == 'forcempower') {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ));
                  } else if (Webservice.appNickname == 'madhuban') {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => const HomeScreenMadhuwan(),
                    ));
                  }

                  // _userData.put(1, user.memberid);
                  print(_userData.get('user_data_key'));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'WELCOME 🙏 ${user.firstname} ${user.lastname}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppThemes.brc_textcolor),
                      ),
                      backgroundColor: AppThemes.brc_otp_success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${user.processMessage}',
                        style: TextStyle(color: AppThemes.brc_textcolor),
                      ),
                      backgroundColor: AppThemes.brc_otp_error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Webservice.appNickname == 'forcempower'
                    ? AppThemes.getBackground()
                    : AppThemes.getBackground(),
                shape: const CircleBorder(),
                minimumSize: const Size(60, 60),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      // Show CircularProgressIndicator while loading
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppThemes.brc_textcolor,
                      ),
                    )
                  : const Icon(
                      Icons.arrow_forward,
                      size: 30,
                      color: AppThemes.brc_textcolor,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
