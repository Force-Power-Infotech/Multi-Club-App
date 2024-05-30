import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_club_app/bases/api/birthday_today.dart';
import 'package:multi_club_app/bases/api/user_otp.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/profile_screen.dart';
import 'package:multi_club_app/screens/widgets/PulsatingButton.dart';
import 'package:url_launcher/url_launcher.dart';

class BirthdayAnniversaryScreen extends StatelessWidget {
  void launchWhatsApp(
      BuildContext context, String phoneNumber, String message) async {
    final String whatsappUrl =
        "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeFull(message)}";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch WhatsApp'),
          duration: Duration(seconds: 3), // Adjust as needed
        ),
      );
    }
  }

  String formattedDate(String dateStr) {
    // Parse the date string
    DateTime date = DateFormat("dd-MM-yyyy").parse(dateStr);

    // Format the date as "dd MMM"
    String formatted = DateFormat("dd MMM").format(date);

    return formatted;
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
          'Birthdays And Anniversaries',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DobAPI>(
        future: DobAPI.details(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final memberNames = snapshot.data?.memberName ?? [];
            final memberDobs = snapshot.data?.memberDob ?? [];
            final memberContacts = snapshot.data?.memberContact ?? [];
            final memberIDs = snapshot.data?.memberID ?? [];

            if (memberNames.isEmpty) {
              return Center(
                child: Text(
                  'Nothing to show',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: memberNames.length,
                itemBuilder: (context, index) {
                  final name = memberNames[index];
                  final date = memberDobs[index];
                  final contact = memberContacts[index] ?? '';
                  final id = memberIDs[index] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Open the profile screen with the correct memberId
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            memberId: id,
                          ),
                        ));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 24,
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  formattedDate(date),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          PulsatingButton(
                            onPressed: () {
                              if (contact.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('No contact number available'),
                                  ),
                                );
                              } else {
                                launchWhatsApp(
                                  context,
                                  contact,
                                  "Happy birthday!!",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
