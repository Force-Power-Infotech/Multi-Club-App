import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/profile_edit.dart';
import 'package:multi_club_app/bases/api/profile_view.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late Future<ProfieviewAPI> _profileData;

  late TextEditingController _nameController;
  late TextEditingController _membershipController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _profileData = ProfieviewAPI.list(); // Fetch profile data from API

    _profileData.then((snapshot) {
      _nameController = TextEditingController(text: '${snapshot.memberName}');
      _membershipController =
          TextEditingController(text: '${snapshot.memberId}');
      _dobController = TextEditingController(text: '${snapshot.memberDob}');
      _phoneController = TextEditingController(text: '${snapshot.memberPhone}');
      _emailController = TextEditingController(text: '${snapshot.memberEmail}');
      _addressController = TextEditingController(text: '${snapshot.address}');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _membershipController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

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
            color: AppThemes.brc_textcolor,
          ),
        ),
      ),
      body: FutureBuilder<ProfieviewAPI>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String imageUrl = snapshot.data!.memberImageUrl ?? '';

            return ListView(
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
                            color: AppThemes
                                .brc_textcolor, // Change color as needed
                          ),
                          Container(
                            height: 50, // Set the height as needed
                            color: AppThemes
                                .getBackground(), // Change color as needed
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
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: imageUrl != null &&
                                                imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              )
                                            : Container(
                                                color: Colors
                                                    .grey, // Grey color for the circle
                                                width: 100,
                                                height: 100,
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppThemes.getBackground(),
                            borderRadius: const BorderRadius.only(
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
                                  color: AppThemes.brc_textcolor,
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
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Name',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data!.memberName}', // Replace with actual phone number
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                if (Webservice.appNickname != 'madhuban')
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: AppThemes
                                                    .brc_not_available_bg,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: const Text(
                                                '10',
                                                style: TextStyle(
                                                  fontSize: 16,
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
                                if (Webservice.appNickname != 'madhuban')
                                  const Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          const SizedBox(
                                              width:
                                                  12.0), // Add some space between text and text field
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical:
                                                    4.0), // Adjust padding as needed
                                            decoration: BoxDecoration(
                                              // Background color
                                              color: AppThemes
                                                  .brc_not_available_bg,
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Adjust border radius as needed
                                            ),
                                            child: Text(
                                              '${snapshot.data!.memberId}', // Replace with actual date
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
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
                                          SizedBox(
                                              width:
                                                  12.0), // Add some space between text and text field
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical:
                                                    4.0), // Adjust padding as needed
                                            decoration: BoxDecoration(
                                              // Background color
                                              color: AppThemes
                                                  .brc_not_available_bg,
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Adjust border radius as needed
                                            ),
                                            child: Text(
                                              '${snapshot.data!.memberDob}', // Replace with actual date
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
                                // Phone Number
                                Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Phone Number',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data!.memberPhone}', // Replace with actual phone number
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                // Email
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter email',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                // Address
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      TextField(
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter address',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
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
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppThemes.getBackground(),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 64.0, left: 32, right: 32, top: 32),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Retrieve text from controllers
                      String email = _emailController.text;
                      String address = _addressController.text;

                      // Call the API to post data
                      try {
                        ProfileEditAPI response =
                            await ProfileEditAPI.details(email, address);
                        // Handle the response here if needed
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${response.processMessage}',
                              style: const TextStyle(
                                  color: AppThemes.brc_textcolor),
                            ),
                            backgroundColor: AppThemes.brc_otp_success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        print('API response: $response');
                      } catch (e) {
                        // Handle any errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${e}',
                              style: const TextStyle(
                                  color: AppThemes.brc_textcolor),
                            ),
                            backgroundColor: AppThemes.brc_otp_error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        print('Error posting data: $e');
                      }

                      // Add your update logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.getLightColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the border radius as needed
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: const Center(
                        child: Text(
                          'UPDATE',
                          style: TextStyle(
                              fontSize: 16.0), // Adjust the font size as needed
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
