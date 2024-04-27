import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
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
          'Edit Details',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppThemes.brc_textcolor),
        ),
        // centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Image.asset(
        //       'assets/images/edit_profile.png',
        //       width: 18,
        //       height: 18,
        //     ),
        //     onPressed: () {
        //       // Add onPressed action for the helpdesk icon
        //       // Navigator.of(context).push(MaterialPageRoute(
        //       //   builder: (_) => const ContactUs(),
        //       // ));
        //     },
        //   ),
        // ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 160, // Set a fixed height for the Column
            child: Column(
              children: [
                // Image with stack
                Stack(
                  children: [
                    // Second rectangle section
                    Container(
                      height: 160, // Set the height as needed
                      color: AppThemes.brc_textcolor, // Change color as needed
                    ),
                    Container(
                      height: 50, // Set the height as needed
                      color:
                          AppThemes.getBackground(), // Change color as needed
                    ),
                    // Image
                    Positioned(
                      top: -8,
                      left: 0,
                      right: 0, // Align image horizontally to the center
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppThemes.getBackground(),
                                  // Set the color of the border
                                  width: 8, // Set the width of the border
                                ),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape
                                      .circle, // Ensures the container is circular
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.3), // Adjust shadow color and opacity as needed
                                      spreadRadius:
                                          1, // Adjust spread radius as needed
                                      blurRadius:
                                          4, // Adjust blur radius as needed
                                      offset: const Offset(
                                          0, 3), // Adjust offset as needed
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/profileimg.png',
                                    fit: BoxFit
                                        .cover, // Ensure the image covers the oval shape
                                    width: 100, // Set the width as needed
                                    height: 100, // Set the height as needed
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                height:
                                    10), // Add space between the profile image and the text
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: AppThemes.brc_textcolor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity, // Adjust width as needed

                    decoration: BoxDecoration(
                      color: AppThemes.getBackground(), // Color for the header
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'EDIT',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppThemes
                                .brc_textcolor, // Text color for the header
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppThemes.brc_profilecard_color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'First Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                                Text(
                                  'Mohit Agarwal', // Replace with actual phone number
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Handicap',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical:
                                              4.0), // Adjust padding as needed
                                      decoration: BoxDecoration(
                                        color: AppThemes
                                            .brc_not_available_bg, // Background color
                                        borderRadius: BorderRadius.circular(
                                            4.0), // Adjust border radius as needed
                                      ),
                                      child: const Text(
                                        '10', // Replace with actual date
                                        style: TextStyle(
                                          fontSize:
                                              16, // Increase font size for highlighted text
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'MemberShip Number',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical:
                                              4.0), // Adjust padding as needed
                                      decoration: BoxDecoration(
                                        color: AppThemes
                                            .brc_not_available_bg, // Background color
                                        borderRadius: BorderRadius.circular(
                                            4.0), // Adjust border radius as needed
                                      ),
                                      child: const Text(
                                        'AK10RU', // Replace with actual date
                                        style: TextStyle(
                                          fontSize:
                                              16, // Increase font size for highlighted text
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Date of Birth',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical:
                                              4.0), // Adjust padding as needed
                                      decoration: BoxDecoration(
                                        color: AppThemes
                                            .brc_not_available_bg, // Background color
                                        borderRadius: BorderRadius.circular(
                                            4.0), // Adjust border radius as needed
                                      ),
                                      child: const Text(
                                        'January 1, 1990', // Replace with actual date
                                        style: TextStyle(
                                          fontSize:
                                              16, // Increase font size for highlighted text
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                                Text(
                                  '+1234567890', // Replace with actual phone number
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                                Text(
                                  'example@example.com', // Replace with actual email
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                                Text(
                                  '123 Street, City', // Replace with actual address
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity, // Adjust width as needed

                    decoration: BoxDecoration(
                      color: AppThemes.getBackground(),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ), // Color for the header
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
