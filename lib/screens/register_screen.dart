import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/register.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/otp_screen.dart'; // Import your OTP screen
import 'package:multi_club_app/bases/api/citychaptername.dart';

class RegisterInputScreen extends StatefulWidget {
  const RegisterInputScreen({super.key});

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
  final TextEditingController _panNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? selectedCity;
  String? selectedChapter;
  String? selectedCountry;
  CityChapterNameAPI? apiData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      apiData = await CityChapterNameAPI.citychapter();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
                            labelText: 'Full Name',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Full name';
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
                            controller: _addressController,
                            labelText: 'Address',
                            icon: Icons.home,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
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
                          if (isLoading)
                            const Center(child: CircularProgressIndicator())
                          else ...[
                            _buildCountryDropdown(),
                            _buildCityDropdown(),
                            _buildChapterDropdown(),
                          ],
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
                                  _phoneNumberController.text,
                                  panNumber: _panNumberController.text,
                                  pincode: _pincodeController.text,
                                  chapter: selectedChapter!,
                                  area: _areaController.text,
                                  city: selectedCity!,
                                  address: _addressController.text,
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

  Widget _buildCityDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedCity,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'City',
          prefixIcon:
              Icon(Icons.location_city, color: AppThemes.getBackground()),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: apiData?.city?.map((City city) {
              return DropdownMenuItem<String>(
                value: city.city,
                child: Text(
                  city.city ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList() ??
            [],
        onChanged: (String? value) {
          setState(() {
            selectedCity = value;
          });
        },
        menuMaxHeight: 300,
        validator: (value) => value == null ? 'Please select a city' : null,
      ),
    );
  }

  Widget _buildChapterDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedChapter,
        decoration: InputDecoration(
          labelText: 'Chapter',
          prefixIcon: Icon(Icons.group, color: AppThemes.getBackground()),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: apiData?.chapter?.map((Chapter chapter) {
              return DropdownMenuItem<String>(
                value: chapter.chapter,
                child: Text(chapter.chapter ?? ''),
              );
            }).toList() ??
            [],
        onChanged: (String? value) {
          setState(() {
            selectedChapter = value;
          });
        },
        validator: (value) => value == null ? 'Please select a chapter' : null,
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedCountry,
        decoration: InputDecoration(
          labelText: 'Country',
          prefixIcon: Icon(Icons.public, color: AppThemes.getBackground()),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: apiData?.country?.map((Country country) {
              return DropdownMenuItem<String>(
                value: country.country,
                child: Text(country.country ?? ''),
              );
            }).toList() ??
            [],
        onChanged: (String? value) {
          setState(() {
            selectedCountry = value;
          });
        },
        validator: (value) => value == null ? 'Please select a country' : null,
      ),
    );
  }
}
