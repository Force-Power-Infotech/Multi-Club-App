import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/council_members.dart';
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
            child: FutureBuilder<CouncilAPI>(
              future: CouncilAPI.list(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Display UI components using the data from the API
                  // Example: Text(snapshot.data?.processMessage ?? '');
                  // Replace Text with your UI components
                  final designations =
                      snapshot.data?.contactDesignationArray ?? [];
                  final names = snapshot.data?.contactNameArray ?? [];

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: designations.length,
                    itemBuilder: (context, index) {
                      return DepartmentInfo(
                        designation: designations[index],
                        name: names[index],
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Add other departmentInfo widgets here as needed
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

class DepartmentInfo extends StatelessWidget {
  const DepartmentInfo({
    Key? key,
    required this.designation,
    required this.name,
  }) : super(key: key);

  final String designation;
  final String name;

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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      designation,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppThemes.brc_spotsbooking_hint_text,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: 16), // Add some space between designation and name
              Expanded(
                flex: 5,
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppThemes.brc_spotsbooking_hint_text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
