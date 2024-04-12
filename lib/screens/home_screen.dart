import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/contact_us.dart';
import 'package:multi_club_app/screens/notification_screen.dart';
import 'package:multi_club_app/screens/profile_screen.dart';
import 'package:multi_club_app/screens/rowing_booking.dart';
import 'package:multi_club_app/screens/side_menu.dart';
import 'package:multi_club_app/screens/sports_booking.dart';
import 'package:multi_club_app/screens/table_booking.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables to track the clicked state of each icon

  bool homeClicked = false;
  bool bookingClicked = false;
  bool directoryClicked = false;
  bool profileClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.brc_background,
        title: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppThemes.brc_bottom_icon.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 19,
            backgroundImage: AssetImage('assets/images/logomain.jpg'),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
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
          IconButton(
            icon: Image.asset(
              'assets/images/helpdesk.png',
              width: 20,
              height: 20,
              color: AppThemes.brc_textcolor,
            ),
            onPressed: () {
              // Add onPressed action for the helpdesk icon
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ContactUs(),
              ));
            },
          ),
        ],
      ),
      // Body and other widgets

      body: ListView(
        children: [
          Column(
            children: [
              // First rectangle section

              // Image with stack
              Stack(
                children: [
                  // Second rectangle section
                  Container(
                    height: 140, // Set the height as needed
                    color: AppThemes.brc_textcolor, // Change color as needed
                  ),
                  Container(
                    height: 50, // Set the height as needed
                    color: AppThemes.brc_background, // Change color as needed
                  ),
                  // Image
                  Positioned(
                    top: 15,
                    left: 147,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: AppThemes.brc_bottom_icon
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 7, // Blur radius
                                offset: Offset(0, 3), // Offset from top
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              'assets/images/profile_img.jpg',
                              scale: 2.8,
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                10), // Add space between the profile image and the text
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                          child: Text(
                            'Hi Rajshri!',
                            style: TextStyle(
                              fontWeight: FontWeight.w600, // Make the text bold
                              fontSize: 18, // Adjust the font size as needed
                            ),
                          ),
                        ),
                      ],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 15), // Add space above the first line of text
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 2.0), // Adjust left padding as needed
                    child: Text(
                      'Events Highlights ', // Text above the boxes
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ), // Adjust font size as needed
                    ),
                  ),
                  SizedBox(height: 15), // Add space between the lines of text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 160,
                            height: 84.74,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  AppThemes.brc_gradient_light_color,
                                  AppThemes.brc_gradient_dark_color,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                            ),

                            // Add any child widgets inside the box if needed
                            child: Center(
                              child: Container(
                                width: 52.7,
                                height: 52.7,
                                child: Stack(
                                  children: [
                                    // Container for the small card
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors
                                              .white, // Example background color
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        // Add any child widgets inside the card if needed
                                      ),
                                    ),
                                    // Icon widget
                                    Positioned(
                                      top:
                                          10, // Adjust the top position as needed
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/Vector.png', // Path to your PNG image
                                          width: 35, // Adjust width as needed
                                          height: 35, // Adjust height as needed
                                          color: AppThemes
                                              .brc_bottom_icon, // Optionally, you can apply color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  8), // Add space between the box and the line
                          Text(
                            'Upcoming Event', // Your text here
                            style: TextStyle(
                              color: AppThemes.brc_bottom_icon, // Text color
                              fontSize: 10, // Text size
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 160,
                            height: 84.74,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  AppThemes.brc_gradient_light_color,
                                  AppThemes.brc_gradient_dark_color,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            // Add any child widgets inside the box if needed
                            child: Center(
                              child: Container(
                                width: 52.7,
                                height: 52.7,
                                child: Stack(
                                  children: [
                                    // Container for the small card
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppThemes
                                              .brc_textcolor, // Example background color
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        // Add any child widgets inside the card if needed
                                      ),
                                    ),
                                    // Icon widget
                                    Positioned(
                                      top:
                                          10, // Adjust the top position as needed
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/gallery.png', // Path to your PNG image
                                          width: 35, // Adjust width as needed
                                          height: 35, // Adjust height as needed
                                          color: AppThemes.brc_bottom_icon,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  8), // Add space between the box and the line
                          Text(
                            'Event Gallery', // Your text here
                            style: TextStyle(
                              color: AppThemes.brc_bottom_icon, // Text color
                              fontSize: 10, // Text size
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      'Create bookings ', // Text above the boxes
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ), // Adjust font size as needed
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        // First rectangular box
                        HomeMenuButton(
                          asset: 'assets/images/tablebooking.jpg',
                          label: 'Table Booking',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const TableBooking(),
                            ));
                          },
                        ),
                        // Second rectangular box
                        HomeMenuButton(
                          asset: 'assets/images/sportsbooking.jpg',
                          label: 'Sports Booking',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const SportsBooking(),
                            ));
                          },
                        ),
                        // Third rectangular box
                        HomeMenuButton(
                          asset: 'assets/images/rowingbooking.jpg',
                          label: 'Rowing Booking',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const RowingBooking(),
                            ));
                          },
                        ),
                        // Fourth rectangular box
                        HomeMenuButton(
                          asset: 'assets/images/otherbooking.jpg',
                          label: 'Other Booking',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const ContactUs(),
                            ));
                          },
                        ),
                      ],
                    ),
                  )

                  // Add space between the lines of text
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: SideMenu(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppThemes.brc_bottom_icon.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomAppBar(
          color: AppThemes.brc_textcolor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeScreenBottomIcon(
                asset: 'assets/images/home.png',
                label: 'Home',
                wheretoGo: () =>
                    const HomeScreen(), // Wrap ProfileScreen inside a function
              ),
              HomeScreenBottomIcon(
                asset: 'assets/images/mybooking.png',
                label: 'My Booking',
                wheretoGo: () =>
                    ProfileScreen(), // Wrap ProfileScreen inside a function
              ),
              HomeScreenBottomIcon(
                asset: 'assets/images/Frame.png',
                label: 'Directory',
                wheretoGo: () =>
                    const ProfileScreen(), // Wrap ProfileScreen inside a function
              ),
              HomeScreenBottomIcon(
                asset: 'assets/images/profilelogo.png',
                label: 'profile',
                wheretoGo: () =>
                    ProfileScreen(), // Wrap ProfileScreen inside a function
              ),
            ],
          ),
        ),
      ),
    );
  }
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
            style: TextStyle(
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
              offset: Offset(0, 3),
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
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
