import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:multi_club_app/bases/api/birthday_today.dart';
import 'package:multi_club_app/bases/api/event_details.dart';
import 'package:multi_club_app/bases/api/profile_view.dart';
import 'package:multi_club_app/bases/api/sponsor.dart';
import 'package:multi_club_app/bases/api/user_otp.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:multi_club_app/screens/BirthdayAnniversaryScreen.dart';
import 'package:multi_club_app/screens/PrivilegeListScreen.dart';
import 'package:multi_club_app/screens/directory.dart';
import 'package:multi_club_app/screens/event_details_screen.dart';
import 'package:multi_club_app/screens/events_screen.dart';
import 'package:multi_club_app/screens/notification_screen.dart';
import 'package:multi_club_app/screens/profile_screen.dart';
import 'package:multi_club_app/screens/side_menu.dart';
import 'package:multi_club_app/screens/widgets/CaroselSponsor.dart';
import 'package:multi_club_app/screens/widgets/CarouselWidget.dart';
import 'package:multi_club_app/screens/widgets/PulsatingButton.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenMadhuwan extends StatefulWidget {
  const HomeScreenMadhuwan({Key? key}) : super(key: key);

  @override
  _HomeScreenMadhuwanState createState() => _HomeScreenMadhuwanState();
}

class _HomeScreenMadhuwanState extends State<HomeScreenMadhuwan> {
  Color _getBorderColor(String? passType) {
    switch (passType) {
      case 'GoldenPass':
        return const Color(0xFFFFD700);
      case 'TogetherPass':
        return const Color(0xFF3B82F6);
      default:
        return Colors.white;
    }
  }

  String _getPassImage(String? passType) {
    if (_showQRAnimation) {
      return 'assets/images/qrlogo2.gif';
    } else {
      switch (passType) {
        case 'GoldenPass':
          return 'assets/images/goldenpass.gif';
        case 'TogetherPass':
          return 'assets/images/togetherpass.gif';
        default:
          return 'assets/images/qrlogo.gif'; // still gif for regular users
      }
    }
  }

  late Future<ProfieviewAPI> _profileData;

  // Define a global variable to store the username
  String? globalUsername;
  String? globalImg;
  String? globalPass;
  String? globalmemberID;
  bool _showQRAnimation = true;

// In your accessMemberIdFromHive method
  Future<void> accessMemberIdFromHive() async {
    String? username = await UserDataRepository.getMembername();
    if (username != null) {
      print('Access Code: $username');
      // Set the value of the globalUsername variable
      setState(() {
        globalUsername = username;
      });
    } else {
      print('Access code not found');
    }
  }

  Future<void> memberID() async {
    String? memberID = await UserDataRepository.getMemberID();
    if (memberID != null) {
      print('memberID: $memberID');
      // Set the value of the globalUsername variable
      setState(() {
        globalmemberID = memberID;
      });
    } else {
      print('memberID not found');
    }
  }

  // In your accessMemberIdFromHive method
  Future<void> profilimg() async {
    String? username = await UserDataRepository.getprofileimg();
    if (username != null) {
      print('image $username');
      // Set the value of the globalUsername variable
      globalImg = username;
    } else {
      print('Image link not found');
    }
  }

  Future<void> getUserData() async {
    UserOtpAPI? user = await UserDataRepository.getUserData();
    if (user != null && user.pass != null) {
      log('pass ${user.pass}');
      globalPass = user.pass;
    } else {
      log('pass not found');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => accessMemberIdFromHive()); // Call the method here
    _profileData = ProfieviewAPI.list(); // Fetch profile data from API
    memberID();
    getUserData(); // Make sure to call getUserData
    if (globalPass == 'TogetherPass') {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _showQRAnimation = false;
          });
        }
      });
    }
  }

  bool homeClicked = false;
  bool bookingClicked = false;
  bool directoryClicked = false;
  bool profileClicked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void launchWhatsApp(
      BuildContext context, String phoneNumber, String message) async {
    // Format phone number: remove non-digits and ensure country code
    String formattedNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (!formattedNumber.startsWith('91')) {
      formattedNumber = '91$formattedNumber';
    }

    // Create both types of URLs for maximum compatibility
    final Uri whatsappUri = Uri.parse(
        'whatsapp://send?phone=$formattedNumber&text=${Uri.encodeComponent(message)}');
    final Uri webWhatsappUri = Uri.parse(
        'https://wa.me/$formattedNumber?text=${Uri.encodeComponent(message)}');

    try {
      // First try the WhatsApp deep link
      bool launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // If deep link fails, try web URL
        launched = await launchUrl(
          webWhatsappUri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'WhatsApp is not installed. Please install WhatsApp to continue.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Could not open WhatsApp. Please check if WhatsApp is installed.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<String?> getFirstName() async {
    var box = await Hive.openBox('UserData');
    var userData = box.get('user_data_key');
    if (userData != null) {
      return userData['firstname'];
    }
    return null;
  }

  // QR Code generation method
  String generateQRData() {
    // Get current date and time
    final now = DateTime.now();
    final fiveMinLater = now.add(const Duration(minutes: 5));

    // Format date and time as required (yyyy-MM-dd#HH:mm)
    final formatter = DateFormat('yyyy-MM-dd#HH:mm');
    final currentDateTimeFormatted = formatter.format(now);
    final futureDateTimeFormatted = formatter.format(fiveMinLater);

    // Split the formatted string to get date and time parts
    final currentParts = currentDateTimeFormatted.split('#');
    final futureParts = futureDateTimeFormatted.split('#');

    // Format: <current_date>#<current_time>#<current_date>#<current_time+5min>#<member_id>
    String qrData =
        '${currentParts[0]}#${currentParts[1]}#${futureParts[0]}#${futureParts[1]}#$globalmemberID';

    print('Generated QR data: $qrData');
    return qrData;
  }

  // Show QR code in a dialog
  void showQRDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your Access QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250,
                height: 250,
                child: QrImageView(
                  data: generateQRData(),
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Valid for 5 minutes',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Member ID: $globalmemberID',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight +
            80), // Add extra height for the red bar and padding
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer(); // Open the drawer
                },
                icon: const Icon(
                  Icons.menu,
                  color: AppThemes.brc_textcolor,
                ),
                color: Colors.white, // Set the color to white
              ),
              backgroundColor: AppThemes.getBackground(),
              title: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppThemes.brc_bottom_icon.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.asset(
                    'assets/images/madhuwan.jpg',
                    fit: BoxFit.cover,
                    width: 85,
                    height: 30,
                  ),
                ),
              ),
              centerTitle: true,
              actions: [
                // IconButton(
                //   icon: const Icon(
                //     Icons.qr_code,
                //     color: AppThemes.brc_textcolor,
                //   ),
                //   onPressed: () {
                //     // Show QR code dialog
                //     showQRDialog(context);
                //   },
                // ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: AppThemes.brc_textcolor,
                  ),
                  onPressed: () {
                    // Add onPressed action for the notifications icon
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ));
                  },
                ),
                // IconButton(
                //   icon: Image.asset(
                //     'assets/images/helpdesk.png',
                //     width: 20,
                //     height: 20,
                //     color: AppThemes.brc_textcolor,
                //   ),
                //   onPressed: () {
                //     // Add onPressed action for the helpdesk icon
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (_) => const HelpdeskScreen(),
                //     ));
                //   },
                // ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
              decoration: BoxDecoration(
                color: AppThemes.getBackground(),
              ),
              child: FutureBuilder<SponsorAPI>(
                future: SponsorAPI.details(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> imageUrls = snapshot.data?.images ?? [];
                    String firstImageUrl = imageUrls.isNotEmpty
                        ? imageUrls.first
                        : ''; // Get the first image URL
                    List<String> hyperlinks = snapshot.data?.hyperlinks ?? [];
                    String firstHyperlink = hyperlinks.isNotEmpty
                        ? hyperlinks.first
                        : ''; // Get the first hyperlink
                    return GestureDetector(
                      onTap: () {
                        // Redirect to the first hyperlink when tapped
                        if (firstHyperlink.isNotEmpty) {
                          // Add logic here to handle redirection
                          launch(firstHyperlink);
                        }
                      },
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: AppThemes.madhuwan_home_birthday_card,
                          borderRadius: BorderRadius.circular(5),
                          image: firstImageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(firstImageUrl),
                                  fit: BoxFit.fill,
                                )
                              : null, // Use DecorationImage only if first image URL is available
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),

      drawer: const SideMenu(),

      // Body and other widgets

      body: FutureBuilder<ProfieviewAPI>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final profileData = snapshot.data!.data?.first;
            if (profileData == null) {
              return const Center(child: Text('No profile data available'));
            }

            String imageUrl = profileData.maleImageURL ??
                ''; // Placeholder, replace with actual logic
            print(imageUrl);
            return ListView(
              children: [
                Column(
                  children: [
                    // First rectangle section

                    Stack(
                      children: [
                        // Second rectangle section
                        Container(
                          height: 140, // Set the height as needed
                          color:
                              AppThemes.brc_textcolor, // Change color as needed
                        ),
                        Container(
                          height: 50, // Set the height as needed

                          decoration: BoxDecoration(
                            color: AppThemes.getBackground(),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(
                                  10), // Adjust the top left corner radius as needed
                              bottomRight: Radius.circular(
                                  10), // Adjust the top right corner radius as needed
                            ),
                          ), // Change color as needed
                        ),
                        // Image
                        Positioned(
                          top: 15,
                          left: 0,
                          right: 0, // Align image horizontally to the center
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => ProfileScreen(
                                          memberId: '${globalmemberID}',
                                          gender: 'male'),
                                    ));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Container(
                                      width: 76,
                                      height: 76,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppThemes.brc_bottom_icon
                                                .withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 6,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                              width: 76,
                                              height: 76,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                    size: 40,
                                                  ),
                                                );
                                              },
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            AppThemes
                                                                .brc_bottom_icon),
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
                                // Add space between the profile image and the text
                                FutureBuilder<String?>(
                                  future: getFirstName(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // Show a loading indicator while waiting for data
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      String firstName = snapshot.data ??
                                          ''; // Get the first name, or an empty string if null
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 5),
                                        child: Text(
                                          'Hi $firstName!',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 10), // Add padding only at the top
                  child: Container(
                    color: AppThemes.brc_textcolor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Upcoming Events', // Text above the boxes
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ), // Adjust font size as needed
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EventsScreen()), // Replace EventScreen() with your actual screen
                                  );
                                },
                                child: Text(
                                  'Show more', // Text above the boxes
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppThemes
                                          .getBackground()), // Adjust font size as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<EventAPI>(
                          future: EventAPI.details(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child:
                                    CircularProgressIndicator(), // Show loading indicator while fetching data
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    'Error: ${snapshot.error}'), // Show error message if fetching data fails
                              );
                            } else {
                              // Data has been successfully fetched
                              final eventAPI = snapshot.data;
                              // Check if eventAPI or eventAPI.eventDetails is null before accessing it
                              if (eventAPI != null &&
                                  eventAPI.eventDetails != null) {
                                // Use the event data to populate the home_event_card widgets
                                List<EventDetails> firstThreeEvents =
                                    eventAPI.eventDetails!.take(3).toList();
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: firstThreeEvents.map((event) {
                                      return home_event_card(event: event);
                                    }).toList(),
                                  ),
                                );
                              } else {
                                // Handle case where eventAPI or eventAPI.eventDetails is null
                                return const Center(
                                  child: Text('No events available'),
                                );
                              }
                            }
                          },
                        ), // Add space above the first line of text
                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Birthdays ', // Text above the boxes
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ), // Adjust font size as needed
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BirthdayAnniversaryScreen()), // Replace EventScreen() with your actual screen
                                  );
                                },
                                child: Text(
                                  'Show more', // Text above the boxes
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppThemes
                                          .getBackground()), // Adjust font size as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add space between the lines of text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppThemes.brc_textcolor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 190,
                              child: FutureBuilder<DobAPI>(
                                future: DobAPI.details(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.data == null ||
                                      snapshot.data!.data!.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'Nothing to show',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    );
                                  } else {
                                    final dataList = snapshot.data!.data!;

                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ListView.builder(
                                        itemCount: dataList.length,
                                        itemBuilder: (context, index) {
                                          final member = dataList[index];
                                          final name = member.memberName ?? '';
                                          final date = member.memberDob ?? '';
                                          final contact =
                                              member.memberContact ?? '';
                                          final id = member.memberId ?? '';

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                print('${id}');
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (_) => ProfileScreen(
                                                      memberId: '${id}',
                                                      gender: 'male'),
                                                ));
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    radius: 24,
                                                    child: Text(
                                                      name.isNotEmpty
                                                          ? name[0]
                                                              .toUpperCase()
                                                          : '',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          (() {
                                                            // Split the date string
                                                            List<String> parts =
                                                                date.split('-');
                                                            if (parts.length !=
                                                                3) {
                                                              return date; // Return original date if the format is incorrect
                                                            }

                                                            String day =
                                                                parts[0];
                                                            String month =
                                                                parts[1];
                                                            String year =
                                                                parts[2];

                                                            // List of month names
                                                            List<String>
                                                                months = [
                                                              'January',
                                                              'February',
                                                              'March',
                                                              'April',
                                                              'May',
                                                              'June',
                                                              'July',
                                                              'August',
                                                              'September',
                                                              'October',
                                                              'November',
                                                              'December'
                                                            ];

                                                            // Convert month from number to name
                                                            String monthName =
                                                                months[int.parse(
                                                                        month) -
                                                                    1];

                                                            // Format the date
                                                            return '$monthName $day, $year';
                                                          })(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  PulsatingButton(
                                                    onPressed: () {
                                                      if (contact.isEmpty) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'No contact number available'),
                                                          ),
                                                        );
                                                      } else {
                                                        launchWhatsApp(
                                                          context,
                                                          contact,
                                                          "Happy birthday!!",
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                              )),
                        ),

                        const SizedBox(height: 20),

                        const SizedBox(
                            height:
                                15), // Add space above the first line of text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Privilege', // Text above the boxes
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ), // Adjust font size as needed
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PrivilegeListScreen()), // Replace EventScreen() with your actual screen
                                  );
                                },
                                child: Text(
                                  'Show more', // Text above the boxes
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppThemes
                                          .getBackground()), // Adjust font size as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                        CarouselWidget(),
                        const SizedBox(
                            height:
                                15), // Add space above the first line of text
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 16.0), // Adjust left padding as needed
                          child: Text(
                            'Sponsors', // Text above the boxes
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ), // Adjust font size as needed
                          ),
                        ),
                        CarouselSponsor()

                        // Add space between the lines of text
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No profile data found'));
          }
        },
      ),
      floatingActionButton: globalPass == 'TogetherPass' ? GestureDetector(
        onTap: () {
          showQRDialog(context);
        },
        child: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFF3B82F6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppThemes.brc_blocked_color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              _showQRAnimation ? 'assets/images/qrlogo2.gif' : 'assets/images/togetherpass.gif',
              fit: BoxFit.cover,
              width: 64,
              height: 64,
            ),
          ),
        ),
      ) : null,

      floatingActionButtonLocation: globalPass == 'TogetherPass' 
          ? FloatingActionButtonLocation.centerDocked 
          : null,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppThemes.brc_bottom_icon.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomAppBar(
            color: AppThemes.brc_textcolor,
            shape: globalPass == 'TogetherPass' ? const CircularNotchedRectangle() : null,
            notchMargin: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HomeScreenBottomIcon(
                  asset: 'assets/images/home.png',
                  label: 'Home',
                  wheretoGo: () => const HomeScreenMadhuwan(),
                ),
                HomeScreenBottomIcon(
                  asset: 'assets/images/mybooking.png',
                  label: 'Events',
                  wheretoGo: () => const EventsScreen(),
                ),
                if (globalPass == 'TogetherPass') 
                  const SizedBox(width: 60),
                HomeScreenBottomIcon(
                  asset: 'assets/images/Frame.png',
                  label: 'Directory',
                  wheretoGo: () => const Directory(),
                ),
                HomeScreenBottomIcon(
                  asset: 'assets/images/profilelogo.png',
                  label: 'Profile',
                  wheretoGo: () => ProfileScreen(
                    memberId: globalmemberID,
                    gender: 'male',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class home_event_card extends StatelessWidget {
  final EventDetails event;

  const home_event_card({
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(
                event: event,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppThemes.brc_textcolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImageWidget(event.eventimage),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${event.eventname}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${event.dateForHeading}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${event.description}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildImageWidget(String? imageUrl) {
  try {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl, // URL from the API
        width: 90, // Adjust width of the image as needed
        height: 90, // Adjust height of the image as needed
        fit: BoxFit.cover, // Adjust fit as needed
        errorBuilder: (context, error, stackTrace) {
          // If there's an error loading the image, return the placeholder
          return _buildPlaceholderImage();
        },
      );
    }
  } catch (e) {
    // Handle any exception that might occur during image loading
    print('Error loading image: $e');
  }
  // Return the placeholder if no valid image URL is provided
  return _buildPlaceholderImage();
}

Widget _buildPlaceholderImage() {
  return Container(
    color: Colors.grey, // Placeholder color
    width: 90, // Adjust width of the placeholder as needed
    height: 90, // Adjust height of the placeholder as needed
  );
}

class HomeScreenBottomIcon extends StatelessWidget {
  final String asset;
  final String label;
  final Widget Function() wheretoGo;

  const HomeScreenBottomIcon({
    super.key,
    required this.asset,
    required this.label,
    required this.wheretoGo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => wheretoGo(),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              asset,
              width: 22,
              height: 22,
              color: AppThemes.brc_bottom_icon,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMenuButton extends StatelessWidget {
  final String asset;
  final String label;
  final VoidCallback onPressed;

  const HomeMenuButton({
    Key? key,
    required this.asset,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Handle tap event
      child: Container(
        width: 400,
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(1),
          image: DecorationImage(
            image: AssetImage(asset),
            opacity: 0.5,
            fit: BoxFit.cover,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppThemes.brc_textcolor,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
