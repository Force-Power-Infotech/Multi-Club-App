import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/profile_edit.dart';
import 'package:multi_club_app/bases/api/profile_view.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/profile_edit_screen.dart';
import 'package:flutter/services.dart'; // Import flutter services
import 'package:url_launcher/url_launcher.dart';

import 'dart:ui' as ui;

import 'package:multi_club_app/screens/widgets/CopiedSnackBar.dart';

class ProfileScreen extends StatefulWidget {
  final String? memberId;
  final String gender; // Add gender parameter

  const ProfileScreen({Key? key, required this.memberId, this.gender = 'male'})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ProfieviewAPI> _profileData;
  String? memberIDFromHive; // Member ID fetched from Hive

  @override
  void initState() {
    super.initState();
    _profileData = ProfieviewAPI.list(
        memberId: widget.memberId); // Fetch profile data from API
    memberID();
  }

  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch Email app'),
        ),
      );
    }
  }

// Function to copy the text to clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // Show a SnackBar to indicate successful copy
    // Show the custom Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      CopiedSnackBar(message: 'Phone number copied'),
    );
  }

// Function to fetch member ID from Hive
  // void _fetchMemberIDFromHive() async {
  //   final memberIDfromhive = await UserDataRepository.getMemberID();
  //   memberIDFromHive = memberIDfromhive;
  //   setState(() {}); // Update the UI after fetching member ID
  // }

  Widget _buildFemaleSpecificContainer(Data profileData, String gender) {
    // print(
    //     "profileData (inside _buildFemaleSpecificContainer): ${profileData.memberNameFemale}");

    // Check if gender is female and memberNameFemale is empty
    if (profileData.memberNameFemale == '') {
      return const Center(child: Text('No data available for spouse'));
    }
    return FutureBuilder<ProfieviewAPI>(
      future: _profileData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final profileData = snapshot.data!.data?.first;
          if (profileData == null) {
            return Center(child: Text('No profile data available'));
          }

          String imageUrl = profileData.femaleImageURL ??
              ''; // Placeholder, replace with actual logic
          return Container(
            color: AppThemes.brc_textcolor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'milleniumMams')
                    Container(
                      width: double.infinity, // Adjust width as needed
                      decoration: BoxDecoration(
                        color:
                            AppThemes.getBackground(), // Color for the header
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            'PAYOUT',
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
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'milleniumMams')
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
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'OUTSTANDING',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppThemes
                                                  .brc_tablebooking_dark_text,
                                            ),
                                          ),
                                          Text(
                                            'CREDIT BALANCE',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppThemes
                                                  .brc_tablebooking_dark_text,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '₹2000.00',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height:
                                          16), // Add some space between the row and the button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your button onPressed logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppThemes.getBackground(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      'PAY NOW',
                                      style: TextStyle(
                                          color: AppThemes.brc_textcolor),
                                    ), // Replace 'Click Me' with your button text
                                  ),
                                ],
                              ),
                            ),
                            // Add content for the body here
                          ],
                        ),
                      ),
                    ),
                  Container(
                    width: double.infinity, // Adjust width as needed
                    decoration: BoxDecoration(
                      color: Webservice.appNickname != 'madhuban'
                          ? AppThemes.getBackground() // Color for the header
                          : AppThemes
                              .getBackground(), // Transparent color if appNickname is 'madhuban'
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        widget.gender == 'female'
                            ? 'PERSONAL DETAILS'
                            : 'SPOUSE DETAILS',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppThemes.brc_textcolor,
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
                          if (widget.gender != 'female')
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Name',
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
                                          color: AppThemes.brc_not_available_bg,
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust border radius as needed
                                        ),
                                        child: Text(
                                          profileData.memberNameFemale ?? '',
                                          style: const TextStyle(
                                            fontSize:
                                                16, // Increase font size for highlighted text
                                            fontWeight: FontWeight.w400,
                                            color: AppThemes
                                                .brc_spotsbooking_hint_text,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          if (widget.gender != 'female') const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (Webservice.appNickname != 'madhuban')
                                      const Expanded(
                                        child: Text(
                                          'Date of Joining',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppThemes
                                                .brc_tablebooking_dark_text,
                                          ),
                                        ),
                                      ),
                                    if (Webservice.appNickname != 'madhuban')
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical:
                                                4.0), // Adjust padding as needed
                                        decoration: BoxDecoration(
                                          color: AppThemes.brc_not_available_bg,
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust border radius as needed
                                        ),
                                        child: Text(
                                          profileData.memberFemaleDob ?? '',
                                          style: const TextStyle(
                                            fontSize:
                                                16, // Increase font size for highlighted text
                                            fontWeight: FontWeight.w400,
                                            color: AppThemes
                                                .brc_spotsbooking_hint_text,
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
                                        color: AppThemes.brc_not_available_bg,
                                        borderRadius: BorderRadius.circular(
                                            4.0), // Adjust border radius as needed
                                      ),
                                      child: Text(
                                        profileData.memberFemaleDob ?? '',
                                        style: const TextStyle(
                                          fontSize:
                                              16, // Increase font size for highlighted text
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_spotsbooking_hint_text,
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
                            child: GestureDetector(
                              onLongPress: () {
                                _copyToClipboard(
                                    profileData.memberFemalePhone ?? '');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          AppThemes.brc_tablebooking_dark_text,
                                    ),
                                  ),
                                  Text(
                                    profileData.memberFemalePhone ??
                                        '', // Replace with actual phone number
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          AppThemes.brc_tablebooking_dark_text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          // if (Webservice.appNickname != 'madhuban' &&
                          //     Webservice.appNickname != 'milleniumMams')
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                                Text(
                                  profileData.email ??
                                      '', // Replace with actual email
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // if (Webservice.appNickname != 'madhuban' &&
                          //     Webservice.appNickname != 'milleniumMams')
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppThemes.brc_tablebooking_dark_text,
                                  ),
                                ),
                                Text(
                                  profileData.officeAddress ??
                                      '', // Replace with actual address
                                  style: const TextStyle(
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
                      borderRadius: const BorderRadius.only(
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
          );
        } else {
          return Center(child: Text('Unexpected state'));
        }
      },
    );
  }

  String? globalmemberID;

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

  Widget _buildSocialButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemes.getBackground(),
        foregroundColor: AppThemes.brc_textcolor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleSocialLink(BuildContext context, String? link) {
    if (link == null || link.isEmpty) {
      _showLinkDialog(context, null);
    } else {
      _showLinkDialog(context, link);
    }
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      )) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // Show error snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the link. Please try again later.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showLinkDialog(BuildContext context, String? link) {
    if (link == null || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No link available'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Social Media Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              link,
              style: const TextStyle(
                fontSize: 14,
                color: AppThemes.brc_tablebooking_dark_text,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: link)).then((_) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.copy, size: 20),
                  label: const Text('Copy'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppThemes.brc_tablebooking_dark_text,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _launchUrl(link);
                  },
                  icon: const Icon(Icons.open_in_new, size: 20),
                  label: const Text('Open'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.getBackground(),
                    foregroundColor: AppThemes.brc_textcolor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
          'Profile',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppThemes.brc_textcolor),
        ),
        // centerTitle: true,
        actions: [
          // Social Media Button
          FutureBuilder<ProfieviewAPI>(
            future: _profileData,
            builder: (context, snapshot) {
              return IconButton(
                icon: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.share,
                    size: 18,
                    color: AppThemes.getBackground(),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Social Media Links',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppThemes.brc_tablebooking_dark_text,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (snapshot.hasData &&
                              snapshot.data?.data?.isNotEmpty == true)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                if (snapshot.data?.data?.first
                                        .social_media_link1?.isNotEmpty ??
                                    false)
                                  _buildSocialButton(
                                      'Link 1',
                                      () => _handleSocialLink(
                                          context,
                                          snapshot.data?.data?.first
                                              .social_media_link1)),
                                if (snapshot.data?.data?.first
                                        .social_media_link2?.isNotEmpty ??
                                    false)
                                  _buildSocialButton(
                                      'Link 2',
                                      () => _handleSocialLink(
                                          context,
                                          snapshot.data?.data?.first
                                              .social_media_link2)),
                                if (snapshot.data?.data?.first
                                        .social_media_link3?.isNotEmpty ??
                                    false)
                                  _buildSocialButton(
                                      'Link 3',
                                      () => _handleSocialLink(
                                          context,
                                          snapshot.data?.data?.first
                                              .social_media_link3)),
                                if (snapshot.data?.data?.first
                                        .social_media_link4?.isNotEmpty ??
                                    false)
                                  _buildSocialButton(
                                      'Link 4',
                                      () => _handleSocialLink(
                                          context,
                                          snapshot.data?.data?.first
                                              .social_media_link4)),
                              ],
                            )
                          else
                            const Text(
                              'No social media links available',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
          // Edit Profile Button
          if (widget.memberId == globalmemberID)
            IconButton(
              icon: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: AppThemes.getBackground(),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ProfileEditScreen(),
                ));
              },
            ),
        ],
      ),
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
              return Center(child: Text('No profile data available'));
            }

            String imageUrl = profileData.maleImageURL ??
                ''; // Placeholder, replace with actual logic

            return ListView(
              children: [
                SizedBox(
                  height: 160,
                  child: Stack(
                    children: [
                      // Image section with stack
                      Container(
                        height: 160, // Set the height as needed
                        color:
                            AppThemes.brc_textcolor, // Change color as needed
                      ),
                      Container(
                        height: 50, // Set the height as needed
                        color:
                            AppThemes.getBackground(), // Change color as needed
                      ),
                      // Profile image
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
                                    shape: BoxShape.circle,
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
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
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
                                        }
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
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
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Text(
                                  widget.gender == 'female'
                                      ? profileData.memberNameFemale ?? ''
                                      : profileData.memberNameMale ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                      color: AppThemes
                                          .brc_bottom_icon // Adjust the font size as needed
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppThemes.brc_textcolor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 135.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppThemes.brc_textcolor,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 8), // Adjust padding as needed
                            child: Text(
                              profileData.membershipCode ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppThemes.brc_spotsbooking_hint_text,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: AppThemes.getBackground(),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'MEMBER ID NO.',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: AppThemes.brc_textcolor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.gender == 'female')
                  _buildFemaleSpecificContainer(
                      profileData, '${profileData.memberNameFemale}'),
                Container(
                  color: AppThemes.brc_textcolor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (Webservice.appNickname != 'madhuban' &&
                            Webservice.appNickname != 'milleniumMams')
                          Container(
                            width: double.infinity, // Adjust width as needed

                            decoration: BoxDecoration(
                              color: AppThemes
                                  .getBackground(), // Color for the header
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  'PAYOUT',
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
                        if (Webservice.appNickname != 'madhuban' &&
                            Webservice.appNickname != 'milleniumMams')
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
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'OUTSTANDING',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppThemes
                                                        .brc_tablebooking_dark_text,
                                                  ),
                                                ),
                                                Text(
                                                  'CREDIT BALANCE',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppThemes
                                                        .brc_tablebooking_dark_text,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '₹2000.00',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: AppThemes
                                                    .brc_tablebooking_dark_text,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                16), // Add some space between the row and the button
                                        ElevatedButton(
                                          onPressed: () {
                                            // Add your button onPressed logic here
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppThemes.getBackground(),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: const Text(
                                            'PAY NOW',
                                            style: TextStyle(
                                                color: AppThemes.brc_textcolor),
                                          ), // Replace 'Click Me' with your button text
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Add content for the body here
                                ],
                              ),
                            ),
                          ),
                        Container(
                          width: double.infinity, // Adjust width as needed
                          decoration: BoxDecoration(
                            color: Webservice.appNickname != 'madhuban'
                                ? AppThemes
                                    .getBackground() // Color for the header
                                : AppThemes
                                    .getBackground(), // Transparent color if appNickname is 'madhuban'
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              widget.gender == 'male'
                                  ? 'PERSONAL DETAILS'
                                  : 'SPOUSE DETAILS',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppThemes.brc_textcolor,
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
                                if (widget.gender != 'male')
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
                                                'Name',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppThemes
                                                      .brc_tablebooking_dark_text,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8.0,
                                                  vertical:
                                                      4.0), // Adjust padding as needed
                                              decoration: BoxDecoration(
                                                color: AppThemes
                                                    .brc_not_available_bg,
                                                borderRadius: BorderRadius.circular(
                                                    4.0), // Adjust border radius as needed
                                              ),
                                              child: Text(
                                                profileData.memberNameMale ??
                                                    '',
                                                style: const TextStyle(
                                                  fontSize:
                                                      16, // Increase font size for highlighted text
                                                  fontWeight: FontWeight.w400,
                                                  color: AppThemes
                                                      .brc_spotsbooking_hint_text,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget.gender != 'male') const Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          if (Webservice.appNickname !=
                                              'madhuban')
                                            const Expanded(
                                              child: Text(
                                                'Date of Joining',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppThemes
                                                      .brc_tablebooking_dark_text,
                                                ),
                                              ),
                                            ),
                                          if (Webservice.appNickname !=
                                              'madhuban')
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
                                                profileData.memberMaleDob ?? '',
                                                style: const TextStyle(
                                                  fontSize:
                                                      16, // Increase font size for highlighted text
                                                  fontWeight: FontWeight.w400,
                                                  color: AppThemes
                                                      .brc_spotsbooking_hint_text,
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
                                              // Background color
                                              color: AppThemes
                                                  .brc_not_available_bg,
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Adjust border radius as needed
                                            ),
                                            child: Text(
                                              profileData.memberMaleDob ?? '',
                                              style: const TextStyle(
                                                fontSize:
                                                    16, // Increase font size for highlighted text
                                                fontWeight: FontWeight.w400,
                                                color: AppThemes
                                                    .brc_spotsbooking_hint_text,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                GestureDetector(
                                  onTap: () => _makePhoneCall(
                                      profileData.memberMalePhone ?? ''),
                                  child: Padding(
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
                                          profileData.memberMalePhone ?? '',
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
                                ),
                                const Divider(),
                                // if (Webservice.appNickname != 'madhuban')
                                GestureDetector(
                                  onTap: () =>
                                      _sendEmail(profileData.email ?? ''),
                                  child: Padding(
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
                                        Text(
                                          profileData.email ?? '',
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
                                ),
                                // if (Webservice.appNickname != 'madhuban')
                                const Divider(),
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
                                      Text(
                                        '${profileData.officeAddress ?? ''}', // Replace with actual address
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
                                // Social Media Links Section
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Social Media',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: [
                                          if (profileData.social_media_link1
                                                  ?.isNotEmpty ??
                                              false)
                                            _buildSocialButton(
                                                'Link 1',
                                                () => _handleSocialLink(
                                                    context,
                                                    profileData
                                                        .social_media_link1)),
                                          if (profileData.social_media_link2
                                                  ?.isNotEmpty ??
                                              false)
                                            _buildSocialButton(
                                                'Link 2',
                                                () => _handleSocialLink(
                                                    context,
                                                    profileData
                                                        .social_media_link2)),
                                          if (profileData.social_media_link3
                                                  ?.isNotEmpty ??
                                              false)
                                            _buildSocialButton(
                                                'Link 3',
                                                () => _handleSocialLink(
                                                    context,
                                                    profileData
                                                        .social_media_link3)),
                                          if (profileData.social_media_link4
                                                  ?.isNotEmpty ??
                                              false)
                                            _buildSocialButton(
                                                'Link 4',
                                                () => _handleSocialLink(
                                                    context,
                                                    profileData
                                                        .social_media_link4)),
                                        ],
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
                            borderRadius: const BorderRadius.only(
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
                if (widget.gender == 'male')
                  _buildFemaleSpecificContainer(profileData, 'male'),
              ],
            );
          } else {
            return Center(child: Text('No profile data found'));
          }
        },
      ),
    );
  }
}
