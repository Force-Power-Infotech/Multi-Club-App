import 'package:multi_club_app/bases/themes.dart';
import 'package:flutter/material.dart';

class SeperationBar extends StatelessWidget {
  const SeperationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
        width: double.infinity, // Expand the width to fill the entire screen
        height: 10, // Set the height of the divider
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              5), // Adjust border radius for rounded edges
          color: AppThemes.brc_separation_bar, // Set the color of the divider
        ),
      ),
    );
  }
}
