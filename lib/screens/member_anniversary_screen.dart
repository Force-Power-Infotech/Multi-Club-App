import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/member_anniversary.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MemberAnniversaryScreen extends StatefulWidget {
  const MemberAnniversaryScreen({Key? key}) : super(key: key);

  @override
  _MemberAnniversaryScreenState createState() =>
      _MemberAnniversaryScreenState();
}

class _MemberAnniversaryScreenState extends State<MemberAnniversaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Future<List<MemberAnniversary>> _anniversaryData;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // _anniversaryData = fetchAnniversaryData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchWhatsApp(String phone, String name) async {
    try {
      final message = 'Happy Anniversary dear $name! 🎉';
      final encodedMessage = Uri.encodeComponent(message);
      String formattedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
      if (!formattedPhone.startsWith('91')) {
        formattedPhone = '91$formattedPhone';
      }
      final whatsappUrl = 'https://wa.me/$formattedPhone?text=$encodedMessage';

      log('Attempting to launch WhatsApp for $name with phone: $formattedPhone');

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl),
            mode: LaunchMode.externalApplication);
        log('WhatsApp launched successfully for $name');
      } else {
        log('Failed to launch WhatsApp for $name');
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      log('Error launching WhatsApp: $e');
      throw 'Failed to launch WhatsApp: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppThemes.brc_textcolor),
        ),
        backgroundColor: AppThemes.getBackground(),
        title: const Text(
          'Member Anniversaries',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppThemes.brc_textcolor,
          ),
        ),
      ),
      body: FutureBuilder<List<MemberAnniversary>>(
        future: _anniversaryData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No anniversaries today'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final member = snapshot.data![index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppThemes.getBackground().withOpacity(0.8),
                        AppThemes.getBackground().withOpacity(0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppThemes.getLightColor(),
                              child: Text(
                                (member.memberName ?? 'A')[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.memberName ?? 'Unknown Member',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Anniversary: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(member.membeAnniversaryDate ?? DateTime.now().toString()))}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (member.memberNameFemale != null &&
                                member.memberFemalePhone != null)
                              _buildContactTile(
                                icon: Icons.person,
                                title: member.memberNameFemale!,
                                subtitle: member.memberFemalePhone!,
                                onTap: () => _launchWhatsApp(
                                    member.memberFemalePhone!,
                                    member.memberNameFemale!),
                              ),
                            if (member.memberName != null &&
                                member.memberContact != null)
                              _buildContactTile(
                                icon: Icons.person,
                                title: member.memberName!,
                                subtitle: member.memberContact!,
                                onTap: () => _launchWhatsApp(
                                    member.memberContact!, member.memberName!),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale:
                                      1.0 + (_animationController.value * 0.2),
                                  child: ElevatedButton.icon(
                                    icon: Image.asset(
                                      'assets/images/wpicon.webp',
                                      width: 24,
                                      height: 24,
                                    ),
                                    label:
                                        const Text('Send Anniversary Wishes'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: member.memberContact != null &&
                                            member.memberName != null
                                        ? () => _launchWhatsApp(
                                              member.memberContact!,
                                              member.memberName!,
                                            )
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
