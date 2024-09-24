import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/delete_acount.dart';
import 'package:multi_club_app/bases/api/delete_button_show.dart';
import 'package:multi_club_app/bases/api/profile_edit.dart';
import 'package:multi_club_app/bases/api/profile_view.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:multi_club_app/screens/login_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool _showDeleteButton = false; // Control visibility of the delete button

  late Future<ProfieviewAPI> _profileData;

  late TextEditingController _nameController;
  late TextEditingController _membershipController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _imageController;
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDeleteButtonStatus();
    // Initialize controllers
    _nameController = TextEditingController();
    _membershipController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _imageController = TextEditingController();

    // Fetch profile data from API and update controllers
    _profileData = ProfieviewAPI.list();
    _profileData.then((snapshot) {
      final profile = snapshot.data?.first;
      if (profile != null) {
        setState(() {
          _nameController.text = profile.memberNameMale ?? '';
          _membershipController.text = profile.membershipCode ?? '';
          _dobController.text = profile.memberMaleDob ?? '';
          _phoneController.text = profile.memberMalePhone ?? '';
          _imageController.text = profile.maleImageURL ?? '';
          _emailController.text = profile.memberMalePhone ??
              ''; // Assuming this is the correct field
          _addressController.text =
              profile.officeAddress ?? ''; // Assuming this is the correct field
        });
      }
    }).catchError((error) {
      print('Error fetching profile data: $error');
      // Handle the error accordingly
    });
  }

  Future<void> fetchDeleteButtonStatus() async {
    try {
      DeleteButtonShowApi response = await DeleteButtonShowApi.directory();
      setState(() {
        _showDeleteButton = response.action == "YES";
      });
    } catch (e) {
      print('Error fetching delete button status: $e');
      // Handle error, e.g., show a message or log the error
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _membershipController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _imageController.dispose();
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData &&
              snapshot.data!.data != null &&
              snapshot.data!.data!.isNotEmpty) {
            final profile = snapshot.data!.data!.first;

            _nameController.text = profile.memberNameMale ?? '';
            _membershipController.text = profile.membershipCode ?? '';
            _dobController.text = profile.memberMaleDob ?? '';
            _phoneController.text = profile.memberMalePhone ?? '';
            _emailController.text =
                ''; // Placeholder, update with actual email if available
            _addressController.text =
                ''; // Placeholder, update with actual address if available
            _imageController.text = profile.maleImageURL ?? '';

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
                                        child: Stack(
                                          children: [
                                            _image != null
                                                ? Image.file(
                                                    _image!,
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  )
                                                : ClipOval(
                                                    child: Image.network(
                                                      "${profile.maleImageURL}",
                                                      fit: BoxFit.cover,
                                                      width: 100,
                                                      height: 100,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        } else {
                                                          return Container(
                                                            color: Colors.grey,
                                                            width: 100,
                                                            height: 100,
                                                            child: const Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.white,
                                                              size: 50,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object error,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        return Container(
                                                          color: Colors.grey,
                                                          width: 100,
                                                          height: 100,
                                                          child: const Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                            size: 50,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                            Container(
                                              width: 100,
                                              height: 100,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            ),
                                            Positioned(
                                              top: 0,
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: IconButton(
                                                onPressed: _pickImage,
                                                icon: const Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ],
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
                                        profile.memberNameMale ??
                                            'N/A', // Replace with actual member's name
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
                                if (Webservice.appNickname != 'madhuban' &&
                                    Webservice.appNickname != 'millmams')
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
                                if (Webservice.appNickname != 'madhuban' &&
                                    Webservice.appNickname != 'millmams')
                                  const Divider(),
                                if (Webservice.appNickname != 'millmams')
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
                                              padding: const EdgeInsets
                                                  .symmetric(
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
                                                profile.membershipCode ??
                                                    'N/A', // Replace with actual membership code
                                                style: const TextStyle(
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
                                if (Webservice.appNickname != 'millmams')
                                  const Divider(),
                                if (Webservice.appNickname != 'millmams')
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
                                                'Date of Birth',
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
                                              padding: const EdgeInsets
                                                  .symmetric(
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
                                                profile.memberMaleDob != null &&
                                                        profile.memberMaleDob!
                                                            .isNotEmpty
                                                    ? '${profile.memberMaleDob}'
                                                    : 'N/A',
                                                style: const TextStyle(
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
                                if (Webservice.appNickname != 'millmams')
                                  const Divider(),
                                // Phone Number
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Phone Number',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      Text(
                                        profile.memberMalePhone ??
                                            'N/A', // Replace with actual phone number
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
                                // if (Webservice.appNickname != 'madhuban')

                                // Email
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
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
                                          hintText: profile.email != null &&
                                                  profile.email!.isNotEmpty
                                              ? profile.email
                                              : 'No email found, enter Your email',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
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
                                // if (Webservice.appNickname != 'madhuban')
                                const Divider(),
                                // Address
                                if (Webservice.appNickname != 'millmams')
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
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
                                            hintText:
                                                '${profile.officeAddress}',
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
                                if (Webservice.appNickname != 'millmams')
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
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Retrieve text from controllers
                          // String email = _emailController.text;
                          String address = _addressController.text.isNotEmpty
                              ? _addressController.text
                              : (profile.officeAddress ?? '');
                          String email = _emailController.text.isNotEmpty
                              ? _emailController.text
                              : (profile.email ?? '');
                          // Call the API to post data
                          try {
                            ProfileEditAPI response =
                                await ProfileEditAPI.details(
                                    email, address, _image);
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
                            Navigator.of(context)
                                .pop(); // Navigate back to the previous page

                            print('API response: ${response}');
                          } catch (e) {
                            // Handle any errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '$e',
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
                                  fontSize: 16.0,
                                  color: AppThemes
                                      .brc_textcolor), // Adjust the font size as needed
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0, // Add some space between buttons
                      ),
                      if (_showDeleteButton)
                        ElevatedButton(
                          onPressed: () async {
                            // Assuming you have the userid and phonenumber variables ready
                            String userid = profile.membershipCode ??
                                ''; // Replace with actual user ID
                            String phonenumber = profile.memberMalePhone ??
                                ''; // Replace with actual phone number

                            try {
                              // Call the DeleteAccountApi to delete the account
                              DeleteAccountApi response =
                                  await DeleteAccountApi.deleteaccount(
                                      userid, phonenumber);

                              // Check the response and show appropriate message
                              if (response.status == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Account deleted status: ${response.status}',
                                      style: const TextStyle(
                                          color: AppThemes.brc_textcolor),
                                    ),
                                    backgroundColor: AppThemes.brc_otp_success,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to delete account: ${response.message}, try logging in again !!',
                                      style: const TextStyle(
                                          color: AppThemes.brc_textcolor),
                                    ),
                                    backgroundColor: AppThemes.brc_otp_error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              // Handle any errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error: $e',
                                    style: const TextStyle(
                                        color: AppThemes.brc_textcolor),
                                  ),
                                  backgroundColor: AppThemes.brc_otp_error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              print('Error deleting account: $e');
                            }

                            // Add your update logic here if needed
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
                                'DELETE PROFILE',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppThemes
                                      .brc_textcolor, // Adjust the font size as needed
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // add a delete button here below the update button
              ],
            );
          } else {
            return const Center(child: Text('No profile data found'));
          }
        },
      ),
    );
  }
}
