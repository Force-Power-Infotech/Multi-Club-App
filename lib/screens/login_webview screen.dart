import 'package:flutter/material.dart';
import 'package:multi_club_app/screens/widgets/CustomWebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebViewScreen extends StatelessWidget {
  const LoginWebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login WebView'),
      ),
      body: const CustomWebView(
        initialUrl: 'https://nike-web-bay.vercel.app/',
      ),
    );
  }
}
