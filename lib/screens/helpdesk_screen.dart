import 'package:multi_club_app/screens/widgets/Mailbutton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/help_center.dart';
import 'package:multi_club_app/bases/themes.dart';

class HelpdeskScreen extends StatefulWidget {
  const HelpdeskScreen({Key? key}) : super(key: key);

  @override
  _HelpdeskScreenState createState() => _HelpdeskScreenState();
}

class _HelpdeskScreenState extends State<HelpdeskScreen> {
  late Future<HelpCenterAPI> helpData =
      HelpCenterAPI.details("2024-04-12", "Some Location", "12:00");

  @override
  void initState() {
    super.initState();
    helpData = HelpCenterAPI.details(
        "2024-04-12", "Some Location", "12:00"); // Example params
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
        title: const Text('Help Center',
            style: TextStyle(
                color: AppThemes.brc_textcolor,
                fontWeight: FontWeight.w700,
                fontSize: 15)),
      ),
      body: FutureBuilder<HelpCenterAPI>(
        future: helpData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.helpList?.length ?? 0,
              itemBuilder: (context, index) {
                return DepartmentInfo(
                  department: snapshot.data!.helpList![index],
                );
              },
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}

class DepartmentInfo extends StatelessWidget {
  final HelpList department;

  const DepartmentInfo({
    Key? key,
    required this.department,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppThemes.brc_helpdesk_screen_card_bg.withOpacity(0.3),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            department.name ?? "N/A",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppThemes.brc_spotsbooking_hint_text,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            department.description ??
                                "No description available",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppThemes.brc_helpdesk_text_color,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      // padding: EdgeInsets.zero,
                      icon: Icon(Icons.call, color: AppThemes.getBackground()),
                      onPressed: () async {
                        final String? phoneNumber = department.phone?.trim();
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
                    // IconButton(
                    //   // icon: Image.asset(
                    //   //   'assets/images/whatsapp_icon.png',
                    //   //   width: 20,
                    //   //   height: 20,
                    //   // ),
                    //   icon: Icon(Icons.mail),
                    //   color: AppThemes.getBackground(),
                    //   onPressed: () {
                    //     // WhatsApp action
                    //   },
                    // ),
                    MailButton(
                      email: '${department.email}',
                      subject: "I have some doubt about...",
                      body: "Hello, I would like to discuss...",
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
