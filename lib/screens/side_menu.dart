import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppThemes.brc_gradient_light_color, // Top color
              AppThemes.brc_gradient_dark_color, // Top color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors
                    .transparent, // Set to transparent to show the gradient background
              ),
              child: Text(
                'Home',
                style: TextStyle(
                    color: AppThemes.brc_bottom_icon,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              title: Text('Activities'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text("Member's Directory"),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Reciprocal Clubs'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Bookings'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Club Events'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Gallery'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Associate'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Contact us'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Term & Conditions'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Update UI based on item selected from the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
