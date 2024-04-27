import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:multi_club_app/bases/themes.dart'; // Import your themes or any required packages

class MailButton extends StatelessWidget {
  final String email; // The email address to send to
  final String subject; // Optional: pre-filled subject line
  final String body; // Optional: pre-filled body

  const MailButton({
    Key? key,
    required this.email,
    this.subject = "",
    this.body = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.mail, color: AppThemes.getBackground()),
      onPressed: () async {
        final uri = Uri(
          scheme: 'mailto',
          path: email,
          query: encodeQueryParameters({
            'subject': subject,
            'body': body,
          }),
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot open email app'),
            ),
          );
        }
      },
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
