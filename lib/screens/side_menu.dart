import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/about_screen.dart';
import 'package:multi_club_app/screens/activities_screen.dart';
import 'package:multi_club_app/screens/events_screen.dart';
import 'package:multi_club_app/screens/gallery_screen.dart';
import 'package:multi_club_app/screens/gallery_webview.dart';
import 'package:multi_club_app/screens/helpdesk_screen.dart';
import 'package:multi_club_app/screens/leadership_screen.dart';
import 'package:multi_club_app/screens/login_input_screen.dart';
import 'package:multi_club_app/screens/reciprocal_clubs_screen.dart';
import 'package:multi_club_app/screens/setting_screen.dart';
import 'package:multi_club_app/screens/termAndCondition.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);
  void _launchURL(BuildContext context, String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to launch URL: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String facebookUrl = '';
    String instagramUrl = '';
    String youtubeUrl = '';
    String websiteUrl = '';

    if (Webservice.appNickname == 'madhuban') {
      facebookUrl = 'https://www.facebook.com/madhuwanclubkolkata/';
      instagramUrl = 'https://www.instagram.com/madhuwanclub/';
    } else if (Webservice.appNickname == 'millmams') {
      facebookUrl = 'https://www.facebook.com/millenniummams/';
      youtubeUrl =
          'https://www.youtube.com/channel/UCb2vbCFvqnvmzqS74yRxY-w/videos';
      instagramUrl = 'https://www.instagram.com/millenniummams/';

      websiteUrl = 'https://millenniummams.com/';
    } else {
      facebookUrl = ''; // Provide a default or fallback URL if necessary
    }

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              if (Webservice.appNickname == 'madhuban')
                AppThemes.madhuwan_home_birthday_card, // Top color
              if (Webservice.appNickname == 'madhuban')
                AppThemes.madhuwan_background, // Bottom color
              if (Webservice.appNickname == 'forcempower')
                AppThemes.brc_gradient_light_color,
              if (Webservice.appNickname == 'forcempower')
                AppThemes.brc_gradient_dark_color,
              if (Webservice.appNickname == 'millmams') AppThemes.mm_light_card,
              if (Webservice.appNickname == 'millmams') AppThemes.mm_background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.only(top: 64),
          children: [
            if (Webservice.appNickname != 'madhuban' &&
                Webservice.appNickname != 'millmams')
              Container(
                padding: EdgeInsets.zero,
                child: Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: const Text(
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
                                color:
                                    AppThemes.brc_bottom_icon.withOpacity(0.8),
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
                  GestureDetector(
                    onTap: () {
                      // Update UI based on item selected from the drawer
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AboutScreen(),
                      ));
                    },
                    child: const Text(
                      'About Us',
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
                        builder: (_) => const LeadershipScreen(),
                      ));
                    },
                    child: const Text(
                      'Leadership',
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ActivitiesScreen(),
                        ));
                      },
                      child: const Text(
                        'Activities',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                      },
                      child: const Text(
                        "Member's Directory",
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ReciprocalClubsScreen(),
                        ));
                      },
                      child: const Text(
                        'Reciprocal Clubs',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                      },
                      child: const Text(
                        'Bookings',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const EventsScreen(),
                        ));
                      },
                      child: const Text(
                        'Club Events',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () {
                      // Update UI based on item selected from the drawer
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => GalleryWebView(),
                        // builder: (_) => GalleryScreen(),
                      ));
                    },
                    child: const Text(
                      'Gallery',
                      style: TextStyle(
                        color: AppThemes.brc_bottom_icon,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                      },
                      child: const Text(
                        'Associate',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const HelpdeskScreen(),
                        ));
                      },
                      child: const Text(
                        'Contact us',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname == 'millmams')
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Contact Us'),
                              content: const Text(
                                  'How would you like to provide feedback?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _launchURL(context,
                                        'tel:+91 86177 83048'); // Replace with the phone number you want to call
                                  },
                                  child: const Text('Phone'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _launchURL(context,
                                        'mailto:millenniummams@gmail.com?subject=I have a doubt regarding...&body=I have a doubt regarding...'); // Replace with the email address you want to send to
                                  },
                                  child: const Text('Mail'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Contact Us',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname == 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Update UI based on item selected from the drawer
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (_) => const SettingScreen(),
                  //     ));
                  //   },
                  //   child: const Text(
                  //     'Settings',
                  //     style: TextStyle(
                  //       color: AppThemes.brc_bottom_icon,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  // const Divider(color: AppThemes.brc_bottom_icon, thickness: 1),
                  if (Webservice.appNickname == 'millmams')
                    GestureDetector(
                      onTap: () {
                        // Update UI based on item selected from the drawer
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const TermAndCondition(),
                        ));
                      },
                      child: const Text(
                        'Term & Conditions',
                        style: TextStyle(
                          color: AppThemes.brc_bottom_icon,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (Webservice.appNickname == 'millmams')
                    const Divider(
                        color: AppThemes.brc_bottom_icon, thickness: 1),
                  GestureDetector(
                    onTap: () async {
                      // Delete user data from Hive
                      var box = await Hive.openBox('UserData');
                      // get firebase token
                      String? token = await box.get('firebase_token');
                      // Clear the data stored in the box
                      await box.clear();
                      // Save the firebase token back to the box
                      await box.put('firebase_token', token);
                      // Update UI based on item selected from the drawer
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const LoginInputScreen(),
                      ));
                    },
                    child: const Text(
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
                        // Usage example:
                        RoundedImageButton(
                          imagePath: 'assets/images/facebook.png',
                          url: facebookUrl,
                        ),
                        if (Webservice.appNickname != 'madhuban')
                          RoundedImageButton(
                            imagePath: 'assets/images/youtube.png',
                            url: youtubeUrl,
                          ),
                        RoundedImageButton(
                          imagePath: 'assets/images/insta.png',
                          url: instagramUrl,
                        ),
                        if (Webservice.appNickname != 'madhuban')
                          RoundedImageButton(
                            imagePath: 'assets/images/website.png',
                            url: websiteUrl,
                          ),
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
  final String url;

  const RoundedImageButton(
      {Key? key, required this.imagePath, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ElevatedButton(
        onPressed: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
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
