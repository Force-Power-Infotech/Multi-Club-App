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
  bool isLoading = false;
  bool isEmail = false;
  final input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Webservice.appNickname == 'forcempower'
            ? AppThemes.brc_background
            : AppThemes.getBackground(),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppThemes.brc_textcolor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Enter ${isEmail ? 'Email ID' : 'Mobile Number'}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     setState(() {
                //       isEmail = !isEmail;
                //     });
                //   },
                //   child: Text(
                //     'Use ${isEmail ? 'Mobile Number' : 'Email ID'}',
                //     style: const TextStyle(
                //       color: Colors.blue,
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Input Text Field
            TextField(
              controller: input,
              decoration: InputDecoration(
                hintText: isEmail ? 'Email ID' : 'Mobile Number',
                prefixIcon: Icon(isEmail ? Icons.email : Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Webservice.appNickname == 'forcempower'
                        ? AppThemes.brc_background
                        : AppThemes.getBackground(),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType:
                  isEmail ? TextInputType.emailAddress : TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(isEmail
                    ? null
                    : 10), // Limit to 10 characters for phone number
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]')), // Allow only digits for phone number
              ],
            ),
            const SizedBox(height: 20.0),
            // TextButton: Can't Login? Click Here
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: TextButton(
            //     onPressed: () {
            //       // Navigate to the forgot screen
            //     },
            //     child: const Text(
            //       'Can\'t Login? Click Here',
            //       style: TextStyle(
            //         color: Colors.blue,
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   ),
            // ),
            const Spacer(),
            // ElevatedButton
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                UserLoginAPI user = await UserLoginAPI.login(input.text);
                setState(() {
                  isLoading = false;
                });
                if (user.processStatus == "YES") {
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
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${user.processMessage}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Webservice.appNickname == 'forcempower'
                    ? AppThemes.brc_background
                    : AppThemes.getBackground(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
                elevation: 5,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Proceed',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.brc_textcolor),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
