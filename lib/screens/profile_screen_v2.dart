import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/profile_view.dart';
import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/profile_edit_screen.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenV2 extends StatefulWidget {
  final String? memberId;
  final String gender;
  const ProfileScreenV2(
      {Key? key, required this.memberId, this.gender = 'male'})
      : super(key: key);

  @override
  State<ProfileScreenV2> createState() => _ProfileScreenV2State();
}

class _ProfileScreenV2State extends State<ProfileScreenV2> {
  // --- Social Links Modern UI Widget ---
  Widget _modernSocialLinksRow(Map<String, String?> links) {
    final filtered =
        links.entries.where((e) => (e.value?.isNotEmpty ?? false)).toList();
    if (filtered.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: filtered.map<Widget>((entry) {
          final iconWidget = _getSocialIcon(entry.key);
          return Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: () async {
                final url = entry.value;
                if (url != null && url.isNotEmpty) {
                  final uri = Uri.tryParse(url);
                  if (uri != null) {
                    try {
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      } else {
                        _showCopyLinkDialog(context, url, entry.key);
                      }
                    } catch (e) {
                      _showCopyLinkDialog(context, url, entry.key);
                    }
                  } else {
                    _showCopyLinkDialog(context, url, entry.key);
                  }
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: iconWidget,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showCopyLinkDialog(BuildContext context, String url, String label) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: AppThemes.getLightColor(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link, color: AppThemes.getBackground(), size: 38),
                const SizedBox(height: 16),
                Text(
                  'Could not open $label link',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppThemes.brc_bottom_icon,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  url,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppThemes.getBackground(),
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.getBackground(),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy Link'),
                      onPressed: () async {
                        await Future.delayed(const Duration(milliseconds: 100));
                        Navigator.of(ctx).pop();
                        await _copyToClipboard(url);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Link copied to clipboard'),
                              backgroundColor: AppThemes.getBackground(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppThemes.getBackground(),
                        side: BorderSide(color: AppThemes.getBackground()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Close'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Widget _getSocialIcon(String label) {
    String assetName;
    switch (label.toLowerCase()) {
      case 'facebook':
        assetName = 'assets/images/facebook.png';
        break;
      case 'twitter':
        assetName = 'assets/images/twitter.png';
        break;
      case 'linkedin':
        assetName = 'assets/images/linkedin.png';
        break;
      case 'instagram':
        assetName = 'assets/images/insta.png';
        break;
      default:
        assetName = 'assets/images/link.png';
        break;
    }
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 20,
      child: ClipOval(
        child: Image.asset(
          assetName,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.link, color: AppThemes.getBackground(), size: 22),
        ),
      ),
    );
  }

  late Future<ProfieviewAPI> _profileData;

  String? loginType;

  @override
  void initState() {
    super.initState();
    _profileData = ProfieviewAPI.list(memberId: widget.memberId);
    _fetchLoginType();
  }

  Future<void> _fetchLoginType() async {
    final userData = await UserDataRepository.getUserData();
    setState(() {
      loginType = userData?.login_type;
      log(userData?.login_type ?? 'No login type found');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use gender if provided (and not default), else fallback to loginType
    bool showMale;
    String genderLog = widget.gender;
    if (widget.gender.trim().isNotEmpty &&
        widget.gender != 'male' &&
        widget.gender != 'female') {
      // If gender is set to something custom, fallback to loginType
      if (loginType == 'MEMBER') {
        showMale = true;
      } else if (loginType == 'SPOUSE') {
        showMale = false;
      } else {
        showMale = true;
      }
    } else if (widget.gender.trim().isNotEmpty) {
      showMale = widget.gender.toLowerCase() == 'male';
    } else if (loginType == 'MEMBER') {
      showMale = true;
    } else if (loginType == 'SPOUSE') {
      showMale = false;
    } else {
      showMale = true; // default fallback
    }

    // Log the gender passed to the screen
    log('[ProfileScreenV2] Gender passed: $genderLog');

    return Scaffold(
      backgroundColor: AppThemes.getLightColor(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppThemes.brc_bottom_icon,
                fontSize: 24,
                letterSpacing: 0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppThemes.brc_bottom_icon),
        centerTitle: true,
      ),
      body: FutureBuilder<ProfieviewAPI>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final profile = snapshot.data!.data?.first;
            if (profile == null) {
              return const Center(child: Text('No profile data available'));
            }

            final imageUrl =
                showMale ? profile.memberImageUrl : profile.spouseImageUrl;
            final displayName =
                showMale ? profile.memberNameMale : profile.memberNameFemale;

            // Social links for personal and spouse
            final personalLinks = showMale
                ? {
                    'Facebook': profile.facebook,
                    'Twitter': profile.twitter,
                    'LinkedIn': profile.linkedin,
                    'Instagram': profile.instagram,
                  }
                : {
                    'Facebook': profile.spouseFacebook,
                    'Twitter': profile.spouseTwitter,
                    'LinkedIn': profile.spouseLinkedin,
                    'Instagram': profile.spouseInstagram,
                  };
            final spouseLinks = showMale
                ? {
                    'Facebook': profile.spouseFacebook,
                    'Twitter': profile.spouseTwitter,
                    'LinkedIn': profile.spouseLinkedin,
                    'Instagram': profile.spouseInstagram,
                  }
                : {
                    'Facebook': profile.facebook,
                    'Twitter': profile.twitter,
                    'LinkedIn': profile.linkedin,
                    'Instagram': profile.instagram,
                  };

            // Log what is shown in personal and spouse details
            String personalLog = showMale ? 'male' : 'female';
            String spouseLog = showMale ? 'female' : 'male';
            log('[ProfileScreenV2] Showing in Personal Details: $personalLog');
            log('[ProfileScreenV2] Showing in Spouse Details: $spouseLog');

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
              children: [
                _modernProfileHeader(imageUrl ?? '', displayName ?? 'No Name',
                    profile.membershipCode),
                const SizedBox(height: 32),
                _modernSectionCard(
                    'Personal Details',
                    showMale
                        ? {
                            'Name': profile.memberNameMale,
                            'Phone': profile.memberMalePhone,
                            'DOB': profile.memberMaleDob,
                            'Email': profile.email,
                            'Office Address': profile.officeAddress
                          }
                        : {
                            'Name': profile.memberNameFemale,
                            'Phone': profile.memberFemalePhone,
                            'DOB': profile.memberFemaleDob,
                            'Email': profile.email,
                            'Office Address': profile.officeAddress
                          }),
                _modernSocialLinksRow(personalLinks),
                const SizedBox(height: 20),
                _modernSectionCard(
                    'Spouse Details',
                    showMale
                        ? {
                            'Name': profile.memberNameFemale,
                            'Phone': profile.memberFemalePhone,
                            'DOB': profile.memberFemaleDob
                          }
                        : {
                            'Name': profile.memberNameMale,
                            'Phone': profile.memberMalePhone,
                            'DOB': profile.memberMaleDob
                          }),
                _modernSocialLinksRow(spouseLinks),
              ],
            );
          } else {
            return const Center(child: Text('No profile data found'));
          }
        },
      ),
      floatingActionButton: FutureBuilder<ProfieviewAPI>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final profile = snapshot.data!.data?.first;
            if (profile == null) return SizedBox.shrink();
            return FloatingActionButton(
              heroTag: 'editProfile',
              backgroundColor: AppThemes.brc_bottom_icon,
              elevation: 6,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEditScreen(
                      profileData: profile,
                      showMale: showMale,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.edit, color: Colors.white),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _modernProfileHeader(String imageUrl, String name, String? code) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            AppThemes.getBackground().withOpacity(0.85),
            AppThemes.getLightColor().withOpacity(0.85)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemes.getBackground().withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: CircleAvatar(
              radius: 54,
              backgroundColor: Colors.white,
              backgroundImage:
                  imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person,
                      size: 54, color: AppThemes.getBackground())
                  : null,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppThemes.brc_bottom_icon,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              code ?? '',
              style: TextStyle(
                fontSize: 15,
                color: AppThemes.getBackground(),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernSectionCard(String title, Map<String, String?> details) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppThemes.getLightColor().withOpacity(0.95),
            Colors.white.withOpacity(0.95)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemes.getBackground().withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  title == 'Personal Details'
                      ? Icons.account_circle_outlined
                      : Icons.favorite_outline,
                  color: AppThemes.getBackground(),
                  size: 26,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppThemes.brc_bottom_icon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ...details.entries
                .map((entry) => _modernInfoRow(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _modernInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppThemes.getBackground().withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(_getIcon(label),
                size: 18, color: AppThemes.getBackground()),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.5,
                        color: AppThemes.brc_bottom_icon.withOpacity(0.6))),
                const SizedBox(height: 2),
                Text(value?.isNotEmpty == true ? value! : '-',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppThemes.brc_bottom_icon)),
              ],
            ),
          )
        ],
      ),
    );
  }

  IconData _getIcon(String label) {
    switch (label.toLowerCase()) {
      case 'name':
        return Icons.person_outline;
      case 'phone':
        return Icons.phone_outlined;
      case 'dob':
      case 'date of birth':
        return Icons.cake_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'office address':
      case 'address':
        return Icons.location_on_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
