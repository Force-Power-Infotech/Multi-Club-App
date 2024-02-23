import 'package:flutter/material.dart';
import 'package:multi_club_app/screens/otp_screen.dart';

class LoginInputScreen extends StatefulWidget {
  const LoginInputScreen({super.key});

  @override
  State<LoginInputScreen> createState() => _LoginInputScreenState();
}

class _LoginInputScreenState extends State<LoginInputScreen> {
  // isEmail: bool
  bool isEmail = false;
  // input: TextEditingController
  final input = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                TextButton(
                  onPressed: () {
                    // setState: isEmail
                    setState(() {
                      isEmail = !isEmail;
                    });
                  },
                  child: Text(
                    'Use ${isEmail ? 'Mobile Number' : 'Email ID'}',
                    style: const TextStyle(
                      color: Colors.black,
                      // underline
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
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
            ),
            // TextButton: Can't Login? Click Here
            Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // Navigate to the forgot screen
                },
                style: TextButton.styleFrom(
                  // no padding
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Can\'t Login? Click Here',
                  style: TextStyle(
                    color: Colors.black,
                    // underline
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            // Spacer
            const Spacer(),
            // ElevatedButton: Icon: Arrow Right
            ElevatedButton(
              onPressed: () {
                // check if the input is valid

                // Navigate to the OTP screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const OTPScreen()));
              },
              style: ElevatedButton.styleFrom(
                // circular shape
                shape: const CircleBorder(),
                // fixed size
                minimumSize: const Size(60, 60),
              ),
              child: const Icon(Icons.arrow_forward, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
