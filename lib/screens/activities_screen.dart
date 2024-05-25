import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.getBackground(),
        title: const Text(
          'Sports Booking',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15, // Set text color to white
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 32.0, left: 32, right: 32, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActivitieCard(
                      asset: 'assets/images/rowingimg.png',
                      label: 'Rowing',
                    ),
                    ActivitieCard(
                      asset: 'assets/images/swimming.png',
                      label: 'Swimming',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActivitieCard(
                        asset: 'assets/images/tabletennis.png',
                        label: 'Table-Tennis',
                      ),
                      ActivitieCard(
                        asset: 'assets/images/badminton.png',
                        label: 'Badminton',
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActivitieCard(
                        asset: 'assets/images/darts.png',
                        label: 'Darts',
                      ),
                      ActivitieCard(
                        asset: 'assets/images/squash.png',
                        label: 'Squash',
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActivitieCard(
                        asset: 'assets/images/balls-snooker.png',
                        label: 'Snooker',
                      ),
                      ActivitieCard(
                        asset: 'assets/images/bridge.png',
                        label: 'Bridge',
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActivitieCard(
                        asset: 'assets/images/gy.png',
                        label: 'Gynasium',
                      ),
                      ActivitieCard(
                        asset: 'assets/images/jacuzzi.png',
                        label: 'Jacuzzi',
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActivitieCard(
                        asset: 'assets/images/kidscorner.png',
                        label: 'Kids Corner',
                      ),
                      // ActivitieCard(
                      //   asset: 'assets/images/bridge.png',
                      //   label: 'Bridge',
                      // ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivitieCard extends StatelessWidget {
  final String asset;
  final String label;

  const ActivitieCard({
    Key? key,
    required this.asset,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 136,
          height: 103,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: AppThemes.brc_tablebooking_dark_text.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Image.asset(
            asset,
            width: 48,
            height: 48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppThemes.brc_tablebooking_dark_text),
        ),
      ],
    );
  }
}
