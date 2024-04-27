import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppThemes.brc_textcolor,
          ),
          color: Colors.white, // Set the color to white
        ),
        backgroundColor: AppThemes.getBackground(),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        // centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: 20), // Add some space at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:
                      AppThemes.brc_helpdesk_screen_card_bg.withOpacity(0.15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reminder',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SliderButton(), // Include the SliderButton widget here
                          ],
                        ),
                        SizedBox(height: 20), // Add space between columns

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Notification',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SliderButton(), // Include another SliderButton widget if needed
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 400), // Add space between columns

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'v2.113',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppThemes.brc_spotsbooking_hint_text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SliderButton extends StatefulWidget {
  @override
  _SliderButtonState createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
        });
      },
      child: Container(
        width: 88,
        height: 53,
        decoration: BoxDecoration(
          color:
              _isOn ? AppThemes.slider_button_on : AppThemes.slider_button_off,
          borderRadius: BorderRadius.circular(57),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 200),
              alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 49,
                height: 49,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
