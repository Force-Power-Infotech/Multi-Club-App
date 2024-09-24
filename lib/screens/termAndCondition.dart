import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class TermAndCondition extends StatefulWidget {
  const TermAndCondition({Key? key}) : super(key: key);

  @override
  _TermAndConditionState createState() => _TermAndConditionState();
}

class _TermAndConditionState extends State<TermAndCondition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.getBackground(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppThemes.brc_textcolor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppThemes.brc_textcolor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Terms & Conditions for the Application",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppThemes.brc_spotsbooking_hint_text,
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                ..._buildTermsList(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            Text(
                              "I agree to the terms and conditions",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppThemes.brc_spotsbooking_hint_text,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTermsList() {
    List<String> terms = [
      "Before you register, ensure to have a valid email id and a phone number.",
      "In case user wants to change the mobile no. and email id, the user can do so by registering new mobile no. and email id and cancel the existing registered no. and id.",
      "The mobile application is prohibited to limited usage.",
      "The company can terminate any mobile application user if found misleading and contrary to the policies of the Company without any further intimation to the user.",
      "This mobile application does not create any right in favour of any of the application users.",
      "The company reserves all the right to withdraw the application anytime without any references.",
      "Any disputes are within the jurisdiction of the XXXX Court.",
      "The company may update or change these terms at any time. Continued use of the application constitutes acceptance of such changes.",
      "Users are responsible for maintaining the confidentiality of their login information and for all activities that occur under their account. Mams will not be calling you for any OTP or login details. Please do not share it with anyone. However there an OTP is to be used only to login into the system.",
      "Users are prohibited from engaging in activities that compromise the security, integrity, or functionality of the application, including unauthorized access or use of the system.",
      "User data will be handled in accordance with the company’s privacy policy.",
      "Any feedback or suggestions provided by users regarding the application may be used by the company without any obligation to the user.",
      "The company is not responsible for any service interruptions or technical issues that may prevent users from accessing or using the application.",
      "Users agree to indemnify, defend, and hold harmless the company from any claims, damages, liabilities, costs, or expenses (including legal fees) arising from their use of the application or violation of these terms.",
    ];

    return terms.map((term) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "• ",
              style: TextStyle(
                fontSize: 16,
                color: AppThemes.brc_spotsbooking_hint_text,
              ),
            ),
            Expanded(
              child: Text(
                term,
                style: TextStyle(
                  fontSize: 16,
                  color: AppThemes.brc_spotsbooking_hint_text,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
