import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/api/birthday_today.dart';
import 'package:multi_club_app/bases/api/event_details.dart';
import 'package:multi_club_app/bases/api/profile_view.dart';
import 'package:multi_club_app/bases/api/sponsor.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/contact_us.dart';
import 'package:multi_club_app/screens/directory.dart';
import 'package:multi_club_app/screens/event_details_screen.dart';
import 'package:multi_club_app/screens/events_screen.dart';
import 'package:multi_club_app/screens/helpdesk_screen.dart';
import 'package:multi_club_app/screens/notification_screen.dart';
import 'package:multi_club_app/screens/profile_screen.dart';
import 'package:multi_club_app/screens/rowing_booking.dart';
import 'package:multi_club_app/screens/side_menu.dart';
import 'package:multi_club_app/screens/sports_booking.dart';
import 'package:multi_club_app/screens/table_booking.dart';
import 'package:multi_club_app/screens/widgets/CarouselWidget.dart';
import 'package:multi_club_app/screens/widgets/SponsorSlider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenMillenniumMams extends StatefulWidget {
  const HomeScreenMillenniumMams({Key? key}) : super(key: key);

  @override
  _HomeScreenMillenniumMamsState createState() =>
      _HomeScreenMillenniumMamsState();
}

class _HomeScreenMillenniumMamsState extends State<HomeScreenMillenniumMams> {
  late Future<ProfieviewAPI> _profileData;

  // Define a global variable to store the username
  String? globalUsername;
  String? globalImg;
  String? globalmemberID;
  Future<void> memberID() async {
    String? memberID = await UserDataRepository.getMemberID();
    if (memberID != null) {
      print('memberID atmm: $memberID');
      // Set the value of the globalUsername variable
      setState(() {
        globalmemberID = memberID;
      });
    } else {
      print('memberID not found');
    }
  }

// In your accessMemberIdFromHive method
  Future<void> accessMemberIdFromHive() async {
    String? username = await UserDataRepository.getMembername();
    if (username != null) {
      // print('Access Code: $username');
      // Set the value of the globalUsername variable
      setState(() {
        globalUsername = username;
      });
    } else {
      print('Access code not found');
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

  @override
  void initState() {
    super.initState();
    memberID();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => accessMemberIdFromHive()); // Call the method here
    _profileData = ProfieviewAPI.list(); // Fetch profile data from API
  }

  bool homeClicked = false;
  bool bookingClicked = false;
  bool directoryClicked = false;
  bool profileClicked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void launchWhatsApp(
      BuildContext context, String phoneNumber, String message) async {
    final String whatsappUrl =
        "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeFull(message)}";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch WhatsApp'),
          duration: Duration(seconds: 3), // Adjust as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          Webservice.appNickname == 'milleniumMams'
              ? kToolbarHeight + 0
              : kToolbarHeight + 55,
        ),
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
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white, // Set the background color to white
                  borderRadius: BorderRadius.circular(
                      15), // Set the border radius for round edges
                  boxShadow: [
                    BoxShadow(
                      color:
                          AppThemes.brc_tablebooking_dark_text.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        15), // Match the border radius of the container
                    child: Image.asset(
                      'assets/images/mmmain_logo.png',
                      fit: BoxFit.cover,
                      width: 70,
                      height: 30,
                    ),
                  ),
                ),
              ),
              centerTitle: true,
              actions: [
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
            if (Webservice.appNickname != 'milleniumMams')
              Container(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40, bottom: 5),
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
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppThemes.mm_light_card,
                            borderRadius: BorderRadius.circular(5),
                            image: firstImageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(firstImageUrl),
                                    fit: BoxFit.contain,
                                  )
                                : null, // Use DecorationImage only if first image URL is available
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            // if (Webservice.appNickname == 'milleniumMams')
            //   Container(
            //     height: 55,
            //     decoration: BoxDecoration(
            //       color: AppThemes.getBackground(),
            //       // borderRadius: BorderRadius.circular(5),
            //     ),
            //   ),
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
                                          memberId: '$globalmemberID',
                                          gender: 'male'),
                                    ));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppThemes.brc_bottom_icon
                                                .withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: imageUrl != null &&
                                                imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                width: 76,
                                                height: 75,
                                                // Show a placeholder while the image is loading
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    // Optionally, you can return a loading indicator while the image is loading
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                },
                                                // Handle image loading errors
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Colors
                                                        .grey, // Grey color for the circle
                                                    width: 76,
                                                    height: 75,
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(
                                                color: Colors
                                                    .grey, // Grey color for the circle
                                                width: 76,
                                                height: 75,
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              ),
                                      )),
                                ),

                                const SizedBox(height: 10),
                                // Add space between the profile image and the text
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 5),
                                  child: Text(
                                    'Hi ${globalUsername ?? ''}!', // Use the meberID variable, if it's null, display an empty string
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w600, // Make the text bold
                                      fontSize:
                                          18, // Adjust the font size as needed
                                    ),
                                  ),
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
                        const SizedBox(
                            height:
                                15), // Add space above the first line of text
                        // const Padding(
                        //   padding: EdgeInsets.only(
                        //       left: 16.0), // Adjust left padding as needed
                        //   child: Text(
                        //     'Recent Birthdays ', // Text above the boxes
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w600,
                        //     ), // Adjust font size as needed
                        //   ),
                        // ),
                        // Add space between the lines of text
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: AppThemes.brc_textcolor,
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     height:
                        //         190, // Adjust the height of the container as needed
                        //     child: FutureBuilder<DobAPI>(
                        //       future: DobAPI
                        //           .details(), // Calling the asynchronous method
                        //       builder: (context, snapshot) {
                        //         if (snapshot.connectionState ==
                        //             ConnectionState.waiting) {
                        //           // Show loading indicator while waiting for data
                        //           return Center(
                        //               child: CircularProgressIndicator());
                        //         } else if (snapshot.hasError) {
                        //           // Show error message if there's an error
                        //           return Center(
                        //               child: Text('Error: ${snapshot.error}'));
                        //         } else {
                        //           // Once data is loaded, display the ListView
                        //           final memberNames =
                        //               snapshot.data?.memberName ?? [];
                        //           return ListView.builder(
                        //             itemCount: memberNames.length,
                        //             itemBuilder: (context, index) {
                        //               final name = memberNames[index];
                        //               return Padding(
                        //                 padding: const EdgeInsets.all(16.0),
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Column(
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         Text(
                        //                           name,
                        //                           style: const TextStyle(
                        //                             fontSize: 16,
                        //                             fontWeight: FontWeight.bold,
                        //                             color: AppThemes
                        //                                 .brc_helpdesk_text_color,
                        //                           ),
                        //                         ),
                        //                         const Text(
                        //                           'Member ID: efve',
                        //                           style: TextStyle(
                        //                             fontSize: 12,
                        //                             color: AppThemes
                        //                                 .brc_helpdesk_text_color,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     ElevatedButton(
                        //                       onPressed: () {
                        //                         launchWhatsApp(
                        //                             context,
                        //                             "1234567890",
                        //                             "Hello, this is a test message!");
                        //                       },
                        //                       style: ButtonStyle(
                        //                         padding:
                        //                             MaterialStateProperty.all(
                        //                           EdgeInsets.zero,
                        //                         ), // Remove padding
                        //                         backgroundColor:
                        //                             MaterialStateProperty.all(
                        //                           Colors.transparent,
                        //                         ), // Transparent background
                        //                         elevation:
                        //                             MaterialStateProperty.all(
                        //                           0,
                        //                         ), // Remove shadow
                        //                       ),
                        //                       child: Ink(
                        //                         decoration: BoxDecoration(
                        //                           borderRadius:
                        //                               BorderRadius.circular(8),
                        //                           color: AppThemes
                        //                               .brc_gradient_light_color,
                        //                         ),
                        //                         child: const Padding(
                        //                           padding: EdgeInsets.all(8.0),
                        //                           child: Row(
                        //                             mainAxisAlignment:
                        //                                 MainAxisAlignment
                        //                                     .center,
                        //                             children: [
                        //                               Icon(Icons
                        //                                   .message), // Icon for WhatsApp
                        //                             ],
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               );
                        //             },
                        //           );
                        //         }
                        //       },
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(height: 20),
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
                        ),

                        const SizedBox(
                            height:
                                15), // Add space above the first line of text
                        if (Webservice.appNickname != 'milleniumMams')
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 16.0), // Adjust left padding as needed
                            child: Text(
                              'Privilege', // Text above the boxes
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ), // Adjust font size as needed
                            ),
                          ),
                        if (Webservice.appNickname != 'milleniumMams')
                          CarouselWidget()

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
      bottomNavigationBar: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: Container(
            //     height: 30, // Height of the red bar
            //     decoration: BoxDecoration(
            //       color: Colors.transparent, // Red color for the bar
            //       borderRadius: BorderRadius.circular(5), // Round edges
            //       image: DecorationImage(
            //         image: AssetImage(
            //             'assets/images/demo-logo.png'), // Path to your image asset
            //         fit: BoxFit
            //             .contain, // Cover the entire container with the image
            //       ),
            //     ),
            //   ),
            // ),
            if (Webservice.appNickname != 'milleniumMams') SlideshowWidget(),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.brc_bottom_icon.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                      20), // Adjust the top left corner radius as needed
                  topRight: Radius.circular(
                      20), // Adjust the top right corner radius as needed
                ),
                child: BottomAppBar(
                  color: AppThemes.brc_textcolor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HomeScreenBottomIcon(
                        asset: 'assets/images/home.png',
                        label: 'Home',
                        wheretoGo: () => const HomeScreenMillenniumMams(),
                      ),
                      HomeScreenBottomIcon(
                        asset: 'assets/images/mybooking.png',
                        label: 'Events',
                        wheretoGo: () => const EventsScreen(),
                      ),
                      // if (Webservice.appNickname != 'milleniumMams')
                      HomeScreenBottomIcon(
                        asset: 'assets/images/Frame.png',
                        label: 'Directory',
                        wheretoGo: () => const Directory(),
                      ),
                      HomeScreenBottomIcon(
                        asset: 'assets/images/profilelogo.png',
                        label: 'Profile',
                        wheretoGo: () => ProfileScreen(
                            memberId: '${globalmemberID}', gender: 'male'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
                        "${event.date}",
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
    Key? key, // Corrected key parameter
    required this.asset,
    required this.label,
    required this.wheretoGo,
  }) : super(key: key); // Corrected super call

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Column(
        children: [
          Image.asset(
            asset,
            width: 20,
            height: 20,
            color: AppThemes.brc_bottom_icon, // Used correct color property
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => wheretoGo(), // Corrected function call
        ));
      },
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
