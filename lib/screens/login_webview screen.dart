import 'package:flutter/material.dart';
import 'package:multi_club_app/screens/widgets/CustomWebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebViewScreen extends StatelessWidget {
  final String url;

  const LoginWebViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login WebView'),
      ),
      body: CustomWebView(
        initialUrl: 'https://nike-web-bay.vercel.app/',
      ),
    );
  }
}
