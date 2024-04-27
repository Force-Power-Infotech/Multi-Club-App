// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class DemoGoogleMap extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200, // Adjust height as needed
//       child: WebView(
//         initialUrl: 'https://www.google.com/maps', // Google Maps website URL
//         javascriptMode: JavascriptMode.unrestricted, // Enable JavaScript
//         navigationDelegate: (NavigationRequest request) {
//           if (request.url.startsWith('https://www.google.com/maps')) {
//             return NavigationDecision
//                 .navigate; // Allow navigation to Google Maps website
//           } else {
//             return NavigationDecision
//                 .prevent; // Prevent navigation to other URLs
//           }
//         },
//       ),
//     );
//   }
// }
