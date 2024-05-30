import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/council_members.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadershipScreen extends StatefulWidget {
  const LeadershipScreen({Key? key}) : super(key: key);

  @override
  _LeadershipScreenState createState() => _LeadershipScreenState();
}

class _LeadershipScreenState extends State<LeadershipScreen> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: FutureBuilder<CouncilAPI>(
                future: CouncilAPI.list(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Display UI components using the data from the API
                    final designations =
                        snapshot.data?.contactDesignationArray ?? [];
                    final names = snapshot.data?.contactNameArray ?? [];
                    final phones = snapshot.data?.contactPhoneArray ?? [];
                    final mails = snapshot.data?.contactEmailArray ?? [];

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: designations.length,
                      itemBuilder: (context, index) {
                        return DepartmentInfo(
                          designation: designations[index],
                          name: names[index],
                          phone: phones[index],
                          mail: mails[index],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // Add other departmentInfo widgets here as needed
            // Padding(
            //   padding: EdgeInsets.only(top: 16),
            //   child: Container(
            //     width: double.infinity,
            //     color: AppThemes.brc_leadership_sepreator,
            //     child: Padding(
            //       padding: EdgeInsets.only(top: 8, left: 32, bottom: 8),
            //       child: Text(
            //         'SUBCOMMITTES',
            //         style: TextStyle(
            //             color: AppThemes.brc_helpdesk_text_color,
            //             fontSize: 12,
            //             fontWeight: FontWeight.w600),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
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
                backgroundImage: NetworkImage(name),
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
                  final String? phoneNumber = phone?.trim();
                  if (phoneNumber != null && phoneNumber.isNotEmpty) {
                    final Uri url = Uri.parse('tel:$phoneNumber');
                    print(url);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      // Error handling if the phone app can't be launched
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot launch phone dialer'),
                        ),
                      );
                      print("Failed to launch URL: $url"); // Debug print
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
                  final String? email = mail?.trim();
                  if (email != null && email.isNotEmpty) {
                    final Uri url = Uri.parse('mailto:$email');
                    print(url);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      // Error handling if the phone app can't be launched
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot launch mail'),
                        ),
                      );
                      print("Failed to launch URL: $url"); // Debug print
                    }
                  } else {
                    // Inform the user that there is no phone number available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No MAIL available'),
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
