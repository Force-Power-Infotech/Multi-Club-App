import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/api/user_otp.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/home_screen%20_madhuwan.dart';
import 'package:multi_club_app/screens/home_screen%20_millenniummams.dart';
import 'package:multi_club_app/screens/home_screen_BRC.dart'; // Import your themes file

class OTPScreen extends StatefulWidget {
  final String username;
  const OTPScreen({super.key, required this.username});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool isLoading = false;
  final _userData = Hive.box('UserData');
  final otpControllers = List.generate(4, (_) => TextEditingController());
  final otpFocusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.brc_textcolor,
      appBar: AppBar(
        title: const Text(
          'Enter OTP',
          style: TextStyle(color: AppThemes.brc_textcolor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppThemes.brc_textcolor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppThemes.getBackground(),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 24),
            Text(
              'Please enter the OTP sent to ${widget.username}',
              style: const TextStyle(
                fontSize: 18,
                color: AppThemes.brc_spotsbooking_hint_text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  height: 60,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: otpFocusNodes[index],
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Increased border radius
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 3) {
                          FocusScope.of(context)
                              .requestFocus(otpFocusNodes[index + 1]);
                        }
                      } else {
                        if (index > 0) {
                          FocusScope.of(context)
                              .requestFocus(otpFocusNodes[index - 1]);
                        }
                      }
                    },
                    onSubmitted: (value) {
                      if (index == 3) {
                        otpFocusNodes[index].unfocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });
                      String otpCode = otpControllers.map((c) => c.text).join();
                      UserOtpAPI user =
                          await UserOtpAPI.login(widget.username, otpCode);
                      setState(() {
                        isLoading = false;
                      });

                      if (user.processStatus == "YES") {
                        if (Webservice.appNickname == 'forcempower') {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                          );
                        } else if (Webservice.appNickname == 'madhuban') {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const HomeScreenMadhuwan()),
                          );
                        } else if (Webservice.appNickname == 'millmams') {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) =>
                                    const HomeScreenMillenniumMams()),
                          );
                        }

                        _userData.put(1, user.memberid);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'WELCOME 🙏 ${user.firstname} ${user.lastname}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppThemes.brc_textcolor),
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
                              style: const TextStyle(color: AppThemes.brc_textcolor),
                            ),
                            backgroundColor: AppThemes.brc_otp_error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: AppThemes.getBackground(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppThemes.brc_textcolor,
                      ),
                    )
                  : const Text(
                      'Verify & Proceed',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppThemes.brc_textcolor,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
