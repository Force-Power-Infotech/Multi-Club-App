import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/activities_screen.dart';
import 'package:multi_club_app/screens/events_screen.dart';
import 'package:multi_club_app/screens/helpdesk_screen.dart';
import 'package:multi_club_app/screens/leadership_screen.dart';
import 'package:multi_club_app/screens/login_input_screen.dart';
import 'package:multi_club_app/screens/reciprocal_clubs_screen.dart';
import 'package:multi_club_app/screens/setting_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              if (Webservice.appNickname == 'madhuban')
                AppThemes.madhuwan_home_birthday_card, // Top color
              if (Webservice.appNickname == 'madhuban')
                AppThemes.madhuwan_background, // Bottom color
              if (Webservice.appNickname != 'madhuban')
                AppThemes.brc_gradient_light_color,
              if (Webservice.appNickname != 'madhuban')
                AppThemes.brc_gradient_dark_color,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.only(top: 64),
          children: [
            Container(
              padding: EdgeInsets.zero,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: AppThemes.brc_bottom_icon,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppThemes.brc_bottom_icon.withOpacity(0.8),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Update UI based on item selected from the drawer
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const LeadershipScreen(),
                            ));
                          },
                          child: Text(
                            'Leadership',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppThemes.brc_bottom_icon.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Text(
                          'Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppThemes.brc_bottom_icon.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Webservice.appNickname != 'madhuban')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ActivitiesScreen(),
                        ));
                      },
                      child: Text(
                        'Activities',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () {
                      // Update UI based on item selected from the drawer
                    },
                    child: Text(
                      "Member's Directory",
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ReciprocalClubsScreen(),
                        ));
                      },
                      child: Text(
                        'Reciprocal Clubs',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                      },
                      child: Text(
                        'Bookings',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () {
                      // Update UI based on item selected from the drawer
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const EventsScreen(),
                      ));
                    },
                    child: Text(
                      'Club Events',
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () {
                      // Update UI based on item selected from the drawer
                    },
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                      },
                      child: Text(
                        'Associate',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () {
                      // Update UI based on item selected from the drawer
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const HelpdeskScreen(),
                      ));
                    },
                    child: Text(
                      'Contact us',
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () {
                      // Update UI based on item selected from the drawer
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const SettingScreen(),
                      ));
                    },
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () {
                      // Update UI based on item selected from the drawer
                    },
                    child: Text(
                      'Term & Conditions',
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () async {
                      // Delete user data from Hive
                      var box = await Hive.openBox('UserData');
                      // Clear the data stored in the box
                      await box.clear();
                      // Update UI based on item selected from the drawer
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const LoginInputScreen(),
                      ));
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RoundedImageButton(
                            imagePath: 'assets/images/facebook.png'),
                        RoundedImageButton(
                            imagePath: 'assets/images/youtube.png'),
                        RoundedImageButton(
                            imagePath: 'assets/images/insta.png'),
                        RoundedImageButton(
                            imagePath: 'assets/images/website.png'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedImageButton extends StatelessWidget {
  final String imagePath;

  const RoundedImageButton({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ElevatedButton(
        onPressed: () {
          // Add onPressed action for the button
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: Colors.transparent, // Background color of the button
        ),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
