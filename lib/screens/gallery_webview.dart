import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/widgets/CustomWebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GalleryWebView extends StatelessWidget {
  final GlobalKey<CustomWebViewState> customWebViewKey =
      GlobalKey<CustomWebViewState>();

  GalleryWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppThemes.brc_textcolor,
          ),
        ),
        backgroundColor: AppThemes.getBackground(),
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CustomWebView(
            key: customWebViewKey,
            initialUrl: 'https://club.forcempower.com/auth/gallery_webview.php',
          ),
          Positioned(
            bottom: 20, // Position from the bottom of the screen
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "refresh",
                  onPressed: () {
                    customWebViewKey.currentState?.refresh();
                  },
                  backgroundColor: AppThemes.brc_textcolor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.refresh_rounded, color: Colors.black),
                ),
                const SizedBox(width: 20), // Spacing between buttons
                FloatingActionButton(
                  heroTag: "goBack",
                  onPressed: () {
                    customWebViewKey.currentState?.goBack();
                  },
                  backgroundColor: AppThemes.brc_textcolor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
