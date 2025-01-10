import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/register.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/otp_screen.dart'; // Import your OTP screen

class RegisterInputScreen extends StatefulWidget {
  const RegisterInputScreen({Key? key}) : super(key: key);

  @override
  _RegisterInputScreenState createState() => _RegisterInputScreenState();
}

class _RegisterInputScreenState extends State<RegisterInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Webservice.appNickname == 'forcempower'
            ? AppThemes.getBackground()
            : AppThemes.getBackground(),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppThemes.brc_textcolor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Webservice.appNickname == 'forcempower'
                  ? const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logomain.jpg'),
                      radius: 50,
                    )
                  : Webservice.appNickname == 'madhuban'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/madhuwan.jpg',
                            fit: BoxFit.cover,
                            width: 120,
                            height: 50,
                          ),
                        )
                      : Webservice.appNickname == 'millmams'
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/mmmain_logo.png',
                                fit: BoxFit.cover,
                                width: 120,
                                height: 50,
                              ),
                            )
                          : Container(),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            controller: _firstNameController,
                            labelText: 'First Name',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _middleNameController,
                            labelText: 'Middle Name',
                            icon: Icons.person_outline,
                          ),
                          _buildTextField(
                            controller: _lastNameController,
                            labelText: 'Last Name',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _phoneNumberController,
                            labelText: 'Phone Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _areaController,
                            labelText: 'Area',
                            icon: Icons.location_on,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your area';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _pincodeController,
                            labelText: 'Pincode',
                            icon: Icons.pin_drop,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your pincode';
                              }
                              if (value.length != 6) {
                                return 'Pincode must be 6 digits';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _cityController,
                            labelText: 'City',
                            icon: Icons.location_city,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _panNumberController,
                            labelText: 'PAN Number',
                            icon: Icons.card_membership,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your PAN number';
                              }
                              if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid PAN number';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _chapterController,
                            labelText: 'Chapter',
                            icon: Icons.group,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your chapter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Registration')),
                                );

                                // Call the Register API and handle the response
                                RegisterAPI response =
                                    await RegisterAPI.directory(
                                  _emailController.text,
                                  _firstNameController.text,
                                  _areaController.text,
                                  _cityController.text,
                                  _phoneNumberController.text,
                                  panNumber: _panNumberController.text,
                                  pincode: _pincodeController.text,
                                  chapter: _chapterController.text,
                                );

                                if (response.processStatus == 'YES') {
                                  // Navigate to OTP screen if registration is successful
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OTPScreen(
                                          username: _phoneNumberController
                                              .text), // Pass the text value instead of the controller
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${response.processMessage}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                } else {
                                  // Show an error message if registration fails
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${response.processMessage}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Webservice.appNickname == 'forcempower'
                                      ? AppThemes.getBackground()
                                      : AppThemes.getBackground(),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          prefixIcon: Icon(icon, color: AppThemes.getBackground()),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Webservice.appNickname == 'forcempower'
                    ? AppThemes.getBackground()
                    : AppThemes.getBackground(),
                width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
