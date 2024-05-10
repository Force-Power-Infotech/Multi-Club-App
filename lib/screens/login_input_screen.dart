import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/user_login.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/otp_screen.dart';
import 'package:multi_club_app/bases/themes.dart'; // Import your themes file
import 'package:flutter/services.dart';

class LoginInputScreen extends StatefulWidget {
  const LoginInputScreen({super.key});

  @override
  State<LoginInputScreen> createState() => _LoginInputScreenState();
}

class _LoginInputScreenState extends State<LoginInputScreen> {
  // isEmail: bool
  bool isLoading = false;
  bool isEmail = false;
  // input: TextEditingController
  final input = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify',
          style: TextStyle(color: AppThemes.brc_textcolor),
        ),
        backgroundColor: Webservice.appNickname == 'forcempower'
            ? AppThemes.brc_background
            : AppThemes.getBackground(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Title: Enter Mobile Number
                Text(
                  'Enter ${isEmail ? 'Email ID' : 'Mobile Number'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                // TextButton: Use Email ID/Phone Number
                // TextButton(
                //   onPressed: () {
                //     // setState: isEmail
                //     setState(() {
                //       isEmail = !isEmail;
                //     });
                //   },
                //   child: Text(
                //     'Use ${isEmail ? 'Mobile Number' : 'Email ID'}',
                //     style: const TextStyle(
                //       color: Colors.black,
                //       // underline
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                // ),
              ],
            ),
            // Input Text Field: Mobile Number/Email ID
            TextField(
              controller: input,
              decoration: InputDecoration(
                hintText: isEmail ? 'Email ID' : 'Mobile Number',
                // suffix icon
                suffixIcon: isEmail
                    ? const Icon(Icons.email)
                    : const Icon(Icons.phone_android),
                // underline border
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              keyboardType:
                  isEmail ? TextInputType.emailAddress : TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(isEmail
                    ? null
                    : 10), // Limit to 10 characters for phone number
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]')), // Allow only digits
              ],
            ),
            // TextButton: Can't Login? Click Here
            // Container(
            //   alignment: Alignment.centerLeft,
            //   child: TextButton(
            //     onPressed: () {
            //       // Navigate to the forgot screen
            //     },
            //     style: TextButton.styleFrom(
            //       // no padding
            //       padding: EdgeInsets.zero,
            //     ),
            //     child: const Text(
            //       'Can\'t Login? Click Here',
            //       style: TextStyle(
            //         color: Colors.black,
            //         // underline
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   ),
            // ),
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
                UserLoginAPI user = await UserLoginAPI.login(input.text);
                setState(() {
                  isLoading =
                      false; // Set isLoading to false after data is fetched
                });
                if (user.processStatus == "YES") {
                  // Navigate to the OTP screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OTPScreen(
                              username: input.text,
                            )),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${user.processMessage}',
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
                backgroundColor: Webservice.appNickname == 'forcempower'
                    ? AppThemes.brc_background
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
