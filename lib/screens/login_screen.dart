import 'package:flutter/material.dart';
import 'package:multi_club_app/screens/login_input_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login/Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Round App Logo
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: CircleAvatar(
                // backgroundImage: AssetImage('assets/images/logo.png'),
                radius: 100,
                // backgroundImage: AssetImage('assets/images/logo.png'),
                child: Text('Logo'),
              ),
            ),
            // Description
            const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
            // Login Button
            ElevatedButton(
              onPressed: () {
                // Navigate and replace the current page with login input page
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginInputScreen()));
              },
              style: ElevatedButton.styleFrom(
                // infinite width
                minimumSize: const Size(double.infinity, 50),
                // rounded corners
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
