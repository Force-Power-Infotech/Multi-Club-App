import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // otp: TextEditingController
  final otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OTP',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate to the previous screen
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
              onPressed: () {
                // check if the input is valid

                // Navigate to the Home screen
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
