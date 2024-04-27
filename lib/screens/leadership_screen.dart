import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

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
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: departmentInfo(),
          ),
          departmentInfo(),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Container(
              width: double.infinity,
              color: AppThemes.brc_leadership_sepreator,
              child: Padding(
                padding: EdgeInsets.only(top: 8, left: 32, bottom: 8),
                child: Text(
                  'SUBCOMMITTES',
                  style: TextStyle(
                      color: AppThemes.brc_helpdesk_text_color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class departmentInfo extends StatelessWidget {
  const departmentInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppThemes.getBackground().withOpacity(0.3),
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Department Name',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppThemes.brc_spotsbooking_hint_text,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Add content for the body here
            ],
          ),
        ),
      ),
    );
  }
}
