import 'package:flutter/material.dart';
import 'dart:math';

import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/directory.dart';
import 'package:multi_club_app/screens/events_screen.dart';
import 'package:multi_club_app/screens/home_screen%20_madhuwan.dart';
import 'package:multi_club_app/screens/profile_screen.dart';
import 'package:multi_club_app/screens/profile_screen_v2.dart';

class ModernBottomNavBar extends StatefulWidget {
  const ModernBottomNavBar({super.key});

  @override
  State<ModernBottomNavBar> createState() => _ModernBottomNavBarState();
}

class _ModernBottomNavBarState extends State<ModernBottomNavBar>
    with SingleTickerProviderStateMixin {
  bool _showQR = true;
  late AnimationController _controller;
  String? globalmemberID;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
  }

  void _flipCard() {
    setState(() {
      _showQR = !_showQR;
      _showQR ? _controller.reverse() : _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 20,
      color: AppThemes.brc_textcolor,
      child: SizedBox(
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavIcon('assets/images/home.png', 'Home',
                () => const HomeScreenMadhuwan()),
            _buildNavIcon('assets/images/mybooking.png', 'Events',
                () => const EventsScreen()),
            const SizedBox(width: 48), // Space for FAB
            _buildNavIcon('assets/images/Frame.png', 'Directory',
                () => const Directory()),
            _buildNavIcon(
                'assets/images/profilelogo.png',
                'Profile',
                () =>
                    ProfileScreenV2(memberId: '$globalmemberID',gender: '',)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(String asset, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Image.asset(asset, height: 24, color: Colors.white),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
