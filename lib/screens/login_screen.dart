import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/login_input_screen.dart';
import 'package:multi_club_app/screens/register_screen.dart'; // Import your register screen
import 'package:multi_club_app/bases/themes.dart'; // Import your themes file

class LoginScreen extends StatefulWidget {
  final bool shouldShowRegisterButton;

  const LoginScreen({super.key, this.shouldShowRegisterButton = true});

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppThemes.brc_textcolor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                .getBackground(), // Use custom primary color from light theme
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
                child: Webservice.appNickname == 'forcempower'
                    ? const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/logomain.jpg'),
                        radius: 100,
                      )
                    : Webservice.appNickname == 'madhuban'
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Image.asset(
                              'assets/images/madhuwan.jpg',
                              fit: BoxFit.cover,
                              width: 240,
                              height: 100,
                            ),
                          )
                        : Webservice.appNickname == 'milleniumMams'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: Image.asset(
                                  'assets/images/mmmain_logo.png',
                                  fit: BoxFit.cover,
                                  width: 240,
                                  height: 100,
                                ),
                              )
                            : Container(), // Default case if none of the conditions are met
              ),
            ),

            // Description
            Expanded(
              child: SlideTransition(
                position: _offsetAnimation,
                child: const SingleChildScrollView(
                  child: Text(
                    Webservice.appNickname == 'milleniumMams'
                        ? "Founded in 1993 by Mr. Bishnu Dhanuka and Mr. Sanjay Bhuwania, Millennium Mams has been a trailblazer in empowering women through financial literacy. With chapters in Kolkata, Bangalore, and Mumbai, and a presence in over 22 countries and 40 cities, the organization has a global reach. Millennium Mams is dedicated to enhancing women's financial acumen through comprehensive educational programs, adhering to Warren Buffett's timeless investment principles, and teaching the art of long-term investing and financial planning. Till date, Millennium Mams has empowered over 10,000 women worldwide. The organization offers offline classes in Kolkata and online classes for members in all other locations. The curriculum imparts financial knowledge through various methods, including studying current affairs and business dailies, analyzing balance sheets, participating in annual general meetings (AGMs), tracking global economic trends, and conducting plant visits. These programs aim to build a community of financially independent women who can take charge of their financial futures. Many enterprising women have become successful entrepreneurs and long-term investors with robust portfolios. A significant milestone was the delegation's participation in the Berkshire Hathaway Annual General Meeting in Omaha, Nebraska, highlighting Millennium Mams as India's largest group of women investors and earning recognition in The Sunday Times Magazine, London. Millennium Mams continues to inspire and educate thousands of women globally, promoting financial independence and fostering a community of empowered women worldwide."
                        : Webservice.appNickname == 'brc'
                            ? "Madhuwan Club was seeded by friends in 1980 with an aim to procreate togetherness, forging unforgettable friendships. Staying true to its core, Madhuwan subsists as a unique socio-cultural organisation inclusive of like-minded people. The club fosters fellowship in society wielding entertainment as a catalyst. Entertainment that is created by the organising & performing talent of the member families. Tested over 40 years, the vision of Madhuwan remains the same."
                            : Webservice.appNickname == 'madhuban'
                                ? "Madhuwan Club was seeded by friends in 1980 with an aim to procreate togetherness, forging unforgettable friendships. Staying true to its core, Madhuwan subsists as a unique socio-cultural organisation inclusive of like-minded people. The club fosters fellowship in society wielding entertainment as a catalyst. Entertainment that is created by the organising & performing talent of the member families. Tested over 40 years, the vision of Madhuwan remains the same."
                                : '',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
            // Buttons Row
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate and replace the current page with login input page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginInputScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Webservice.appNickname ==
                                  'forcempower'
                              ? AppThemes.brc_background
                              : AppThemes
                                  .getBackground(), // Use custom primary color from light theme
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Login',
                            style: TextStyle(color: AppThemes.brc_textcolor)),
                      ),
                    ),
                  ),
                  if (widget.shouldShowRegisterButton)
                    const SizedBox(width: 16), // Add spacing between buttons
                  if (widget.shouldShowRegisterButton)
                    Expanded(
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the register input page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterInputScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Webservice.appNickname ==
                                    'forcempower'
                                ? AppThemes.brc_background
                                : AppThemes
                                    .getBackground(), // Use custom primary color from light theme
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Register',
                              style: TextStyle(color: AppThemes.brc_textcolor)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
