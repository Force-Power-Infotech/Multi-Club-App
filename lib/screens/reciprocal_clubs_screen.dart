import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class ReciprocalClubsScreen extends StatefulWidget {
  const ReciprocalClubsScreen({super.key});

  @override
  _ReciprocalClubsScreenState createState() => _ReciprocalClubsScreenState();
}

class _ReciprocalClubsScreenState extends State<ReciprocalClubsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.getBackground(),
        title: const Text(
          'Reciprocal Clubs',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppThemes.brc_textcolor),
        ),
      ),
      body: ListView(
        children: const [
          reciprocalClubCard(),
          reciprocalClubCard(),
          reciprocalClubCard(),
          reciprocalClubCard(),
        ],
      ),
    );
  }
}

class reciprocalClubCard extends StatelessWidget {
  const reciprocalClubCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16),
          child: Text(
            'DHAKA',
            style: TextStyle(
                color: AppThemes.brc_spotsbooking_hint_text,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, left: 16, right: 16, bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppThemes.brc_textcolor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  spreadRadius: 1, // Spread radius
                  blurRadius: 4, // Blur radius
                  offset: const Offset(0, 3), // Shadow offset
                ),
              ],
            ),
            width: double.infinity,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/reciprocal_clubs_demo.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DHAKA CLUB LTD.',
                        style: TextStyle(
                            color: AppThemes.brc_spotsbooking_hint_text,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'High Grounds,',
                              style: TextStyle(
                                  color: AppThemes.brc_spotsbooking_hint_text
                                      .withOpacity(0.4),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Bangalore - 560 001',
                              style: TextStyle(
                                  color: AppThemes.brc_spotsbooking_hint_text
                                      .withOpacity(0.4),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppThemes.getBackground(),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              width: 77,
                              height: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                color: AppThemes.brc_textcolor,
                                iconSize: 11,
                                icon: const Icon(Icons.call),
                                onPressed: () {
                                  // Add functionality for calling
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              decoration: BoxDecoration(
                                color: AppThemes.getBackground(),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              width: 58,
                              height: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                color: AppThemes.brc_textcolor,
                                iconSize: 11,
                                icon: const Icon(Icons.mail),
                                onPressed: () {
                                  // Add functionality for calling
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppThemes.getBackground(),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        width: 140,
                        height: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          color: AppThemes.brc_textcolor,
                          iconSize: 11,
                          icon: const Icon(Icons.language),
                          onPressed: () {
                            // Add functionality for calling
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
