import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/login_input_screen.dart';
import 'package:multi_club_app/bases/themes.dart'; // Import your themes file

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SlideTransition(
            position: _offsetAnimation,
            child: const Text(
              'Login/Register',
              style: TextStyle(color: AppThemes.brc_textcolor),
            ),
          ),
          backgroundColor: Webservice.appNickname == 'forcempower'
              ? AppThemes.brc_background
              : AppThemes
                  .getBackground() // Use custom primary color from light theme
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Round App Logo
            SlideTransition(
              position: _offsetAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                child: Webservice.appNickname == 'forcempower'
                    ? CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/logomain.jpg'),
                        radius: 100,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.asset(
                          'assets/images/madhuwan.jpg',
                          fit: BoxFit.cover,
                          width: 240,
                          height: 100,
                        ),
                      ),
              ),
            ),

            // Description
            SlideTransition(
              position: _offsetAnimation,
              child: const Text(
                "Madhuwan Club was seeded by friends in 1980 with an aim to procreate togetherness, forging unforgettable friendships.Staying true to it's core, Madhuwan subsists as a unique socio-cultural organisation inclusive of like-minded people. The club fosters fellowship in society wielding entertainment as a catalyst.Entertainment that is created by the organising & performing talent of the member families.Tested over 40 years, the vision of Madhuwan remains the same.",
              ),
            ),
            // Login Button
            SlideTransition(
              position: _offsetAnimation,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate and replace the current page with login input page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginInputScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  // infinite width
                  backgroundColor: Webservice.appNickname == 'forcempower'
                      ? AppThemes.brc_background
                      : AppThemes
                          .getBackground(), // Use custom primary color from light theme
                  // Use custom primary color from light theme
                  minimumSize: const Size(double.infinity, 50),
                  // rounded corners
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Login',
                    style: TextStyle(color: AppThemes.brc_textcolor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
