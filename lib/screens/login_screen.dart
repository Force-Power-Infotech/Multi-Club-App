import 'package:flutter/material.dart';
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
        backgroundColor: AppThemes
            .brc_background, // Use custom primary color from light theme
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
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logomain.jpg'),
                  radius: 100,
                ),
              ),
            ),
            // Description
            SlideTransition(
              position: _offsetAnimation,
              child: const Text(
                'Over the years, The Bengal Rowing Club has surged ahead as one of the premier social hubs in the city, offering an unmatched atmosphere that embraces modernity as effortlessly as it holds on to its traditions. With state of the art sporting and fitness facilities, a diverse and delectable culinary repertoire, carefully crafted cultural and musical evenings, carnivals and fiestas, the Bengal Rowing Club has set remarkable standards ensuring that its illustrious legacy only grows richer with every passing year.',
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
                  backgroundColor: AppThemes
                      .brc_background, // Use custom primary color from light theme
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
