import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_club_app/bases/api/birthday_today.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/profile_screen.dart';
import 'package:multi_club_app/screens/profile_screen_v2.dart';
import 'package:multi_club_app/screens/widgets/PulsatingButton.dart';
import 'package:url_launcher/url_launcher.dart';

class BirthdayAnniversaryScreen extends StatelessWidget {
  void launchWhatsApp(
      BuildContext context, String phoneNumber, String message) async {
    // Format phone number - add country code if not present
    String formattedNumber = phoneNumber;
    if (!phoneNumber.startsWith('+')) {
      formattedNumber = '+91${phoneNumber.replaceAll(RegExp(r'[^\d]'), '')}';
    }

    final Uri whatsappUri = Uri.parse(
        "whatsapp://send?phone=${formattedNumber.replaceAll('+', '')}&text=${Uri.encodeFull(message)}");

    try {
      if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch WhatsApp'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WhatsApp is not installed'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  String formattedDate(String dateStr) {
    if (dateStr.isEmpty) {
      return 'No date available';
    }
    try {
      DateTime date = DateFormat("dd-MM-yyyy").parse(dateStr.trim());
      String formatted = DateFormat("dd MMM, yyyy").format(date);
      return formatted;
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppThemes.brc_textcolor,
          ),
          color: Colors.white,
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
          } else if (!snapshot.hasData ||
              snapshot.data!.data == null ||
              snapshot.data!.data!.isEmpty) {
            return Center(
              child: Text(
                'Nothing to show',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            final dataList = snapshot.data!.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final member = dataList[index];
                  final name = member.memberName ?? '';
                  final date = member.memberDob ?? '';
                  final contact = member.memberContact ?? '';
                  final id = member.memberId ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProfileScreenV2(
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // const SizedBox(height: 4),
                                // Text(
                                //   formattedDate(date),
                                //   style: const TextStyle(
                                //     fontSize: 14,
                                //     color: Colors.grey,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
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
