
import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/profile_edit.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


import 'package:multi_club_app/bases/api/profile_view.dart';

class ProfileEditScreen extends StatefulWidget {
  final Data profileData;
  final bool showMale;
  const ProfileEditScreen({Key? key, required this.profileData, required this.showMale}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {


  late TextEditingController _nameController;
  late TextEditingController _membershipController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _imageController;
  // Social media controllers
  late TextEditingController _facebookController;
  late TextEditingController _twitterController;
  late TextEditingController _linkedinController;
  late TextEditingController _instagramController;
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

    // Initialize controllers
    _nameController = TextEditingController();
    _membershipController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _imageController = TextEditingController();
    _facebookController = TextEditingController();
    _twitterController = TextEditingController();
    _linkedinController = TextEditingController();
    _instagramController = TextEditingController();

    // Prefill controllers from passed profile data
    final profile = widget.profileData;
    if (widget.showMale) {
      _nameController.text = profile.memberNameMale ?? '';
      _membershipController.text = profile.membershipCode ?? '';
      _dobController.text = profile.memberMaleDob ?? '';
      _phoneController.text = profile.memberMalePhone ?? '';
      _imageController.text = profile.memberImageUrl ?? '';
      _emailController.text = profile.email ?? '';
      _addressController.text = profile.officeAddress ?? '';
      _facebookController.text = profile.facebook ?? '';
      _twitterController.text = profile.twitter ?? '';
      _linkedinController.text = profile.linkedin ?? '';
      _instagramController.text = profile.instagram ?? '';
    } else {
      _nameController.text = profile.memberNameFemale ?? '';
      _membershipController.text = profile.membershipCode ?? '';
      _dobController.text = profile.memberFemaleDob ?? '';
      _phoneController.text = profile.memberFemalePhone ?? '';
      _imageController.text = profile.spouseImageUrl ?? '';
      _emailController.text = profile.spouseEmail ?? '';
      _addressController.text = profile.officeAddress ?? '';
      _facebookController.text = profile.spouseFacebook ?? '';
      _twitterController.text = profile.spouseTwitter ?? '';
      _linkedinController.text = profile.spouseLinkedin ?? '';
      _instagramController.text = profile.spouseInstagram ?? '';
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
    _facebookController.dispose();
    _twitterController.dispose();
    _linkedinController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profileData;
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
                                                      "${profile.memberImageUrl}",
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
                                widget.showMale
                                  ? (profile.memberNameMale ?? 'N/A')
                                  : (profile.memberNameFemale ?? 'N/A'),
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
                                // Social Media Links
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Facebook',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      TextField(
                                        controller: _facebookController,
                                        decoration: InputDecoration(
                                          hintText: 'Facebook link',
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Twitter',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      TextField(
                                        controller: _twitterController,
                                        decoration: InputDecoration(
                                          hintText: 'Twitter link',
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'LinkedIn',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      TextField(
                                        controller: _linkedinController,
                                        decoration: InputDecoration(
                                          hintText: 'LinkedIn link',
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Instagram',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_tablebooking_dark_text,
                                        ),
                                      ),
                                      TextField(
                                        controller: _instagramController,
                                        decoration: InputDecoration(
                                          hintText: 'Instagram link',
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
                        profile.membershipCode ??
                          'N/A',
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
                        widget.showMale
                          ? (profile.memberMaleDob != null && profile.memberMaleDob!.isNotEmpty ? profile.memberMaleDob! : 'N/A')
                          : (profile.memberFemaleDob != null && profile.memberFemaleDob!.isNotEmpty ? profile.memberFemaleDob! : 'N/A'),
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
                    widget.showMale
                      ? (profile.memberMalePhone ?? 'N/A')
                      : (profile.memberFemalePhone ?? 'N/A'),
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
                      hintText: widget.showMale
                        ? (profile.email != null && profile.email!.isNotEmpty ? profile.email : 'No email found, enter Your email')
                        : (profile.spouseEmail != null && profile.spouseEmail!.isNotEmpty ? profile.spouseEmail : 'No email found, enter Your email'),
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
                                          hintText: profile.officeAddress ?? '',
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
                      String address = _addressController.text.isNotEmpty
                          ? _addressController.text
                          : (profile.officeAddress ?? '');
            String email = _emailController.text.isNotEmpty
              ? _emailController.text
              : (widget.showMale ? (profile.email ?? '') : (profile.spouseEmail ?? ''));
                      String facebook = _facebookController.text;
                      String twitter = _twitterController.text;
                      String linkedin = _linkedinController.text;
                      String instagram = _instagramController.text;

                      try {
                        // Custom API call for social links
                        Uri url = Uri.parse(
                            "${Webservice.rootURL}${Webservice.profileEdit}?nickname=${Webservice.appNickname}");
                        final request = http.MultipartRequest('POST', url);
                        String? memberID =
                            await UserDataRepository.getMemberID();
                        request.fields.addAll({
                          'organization_id': Webservice.appNickname,
                          'member_id': '$memberID',
                          'email': email,
                          'address': address,
                          if (!widget.showMale) ...{
                            'spouse_facebook': facebook,
                            'spouse_twitter': twitter,
                            'spouse_linkedin': linkedin,
                            'spouse_instagram': instagram,
                          } else ...{
                            'facebook': facebook,
                            'twitter': twitter,
                            'linkedin': linkedin,
                            'instagram': instagram,
                          }
                        });
                        if (_image != null && _image!.existsSync()) {
                          request.files.add(await http.MultipartFile.fromBytes(
                            'member_image',
                            await _image!.readAsBytes(),
                            filename: _image!.path.split('/').last,
                          ));
                        }
                        http.StreamedResponse response = await request.send();
                        String responseString =
                            await response.stream.bytesToString();
                        ProfileEditAPI apiResponse =
                            ProfileEditAPI.fromJson(jsonDecode(responseString));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${apiResponse.processMessage}',
                              style: const TextStyle(
                                  color: AppThemes.brc_textcolor),
                            ),
                            backgroundColor: AppThemes.brc_otp_success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        print('API response: ${apiResponse}');
                      } catch (e) {
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
                ),
              ],
            
        
      ),
    );
  }
}
