import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/council_members.dart'; // Ensure the path is correct
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadershipScreen extends StatefulWidget {
  const LeadershipScreen({Key? key}) : super(key: key);

  @override
  _LeadershipScreenState createState() => _LeadershipScreenState();
}

class _LeadershipScreenState extends State<LeadershipScreen> {
  String selectedCategory = 'Executive Committee';
  String selectedCity = 'Kolkata'; // Default city
  final List<String> cities = ['Kolkata', 'Mumbai', 'Bangalore'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.getBackground(),
        title: const Text(
          'Leadership',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppThemes.brc_textcolor),
        ),
      ),
      body: Column(
        children: [
          if (Webservice.appNickname == 'madhuban')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: <String>[
                  'Executive Committee',
                  'General Committee',
                  'Special Invitee',
                  'Advisory Committee'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          if (Webservice.appNickname == 'milleniumMams')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue!;
                  });
                },
                items: cities.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: FutureBuilder<CouncilAPI>(
              future: CouncilAPI.list(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  final allMembers = snapshot.data!.data!;
                  final filteredMembers = Webservice.appNickname == 'madhuban'
                      ? allMembers
                          .where(
                              (member) => member.category == selectedCategory)
                          .toList()
                      : Webservice.appNickname == 'milleniumMams'
                          ? allMembers
                              .where((member) => member.city == selectedCity)
                              .toList()
                          : allMembers;

                  if (filteredMembers.isEmpty) {
                    return Center(child: Text('No members in this category'));
                  }

                  return ListView.builder(
                    itemCount: filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];
                      return DepartmentInfo(
                        designation: member.designation ?? '',
                        name: member.name ?? '',
                        phone: member.memberId ?? '',
                        mail: member.city ?? '',
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DepartmentInfo extends StatelessWidget {
  const DepartmentInfo({
    Key? key,
    required this.designation,
    required this.name,
    required this.phone,
    required this.mail,
  }) : super(key: key);

  final String designation;
  final String name;
  final String phone;
  final String mail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(
              0.3), // Replace with AppThemes.getBackground().withOpacity(0.3)
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: AppThemes.getLightColor(),
                radius: 24,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                  width: 16), // Add some space between avatar and text
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors
                            .black, // Replace with AppThemes.brc_spotsbooking_hint_text
                      ),
                    ),
                    const SizedBox(
                        height:
                            4), // Add some space between name and designation
                    Text(
                      designation,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors
                            .black, // Replace with AppThemes.brc_spotsbooking_hint_text
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.call),
                color: AppThemes.getBackground(),
                onPressed: () async {
                  final String phoneNumber = phone.trim();
                  if (phoneNumber.isNotEmpty) {
                    final Uri url = Uri.parse('tel:$phoneNumber');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      // Error handling if the phone app can't be launched
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot launch phone dialer'),
                        ),
                      );
                    }
                  } else {
                    // Inform the user that there is no phone number available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No phone number available'),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.mail),
                color: AppThemes.getBackground(),
                onPressed: () async {
                  final String email = mail.trim();
                  if (email.isNotEmpty) {
                    final Uri url = Uri.parse('mailto:$email');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      // Error handling if the mail app can't be launched
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot launch mail'),
                        ),
                      );
                    }
                  } else {
                    // Inform the user that there is no email available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No email available'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
