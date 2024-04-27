// import 'package:multi_club_app/bases/userdata_hive.dart';
// import 'package:multi_club_app/bases/webservice.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


// class PriviledgeAPI {
//   String? processStatus;
//   String? processMessage;
//   List<String>? nameArray;
//   List<String>? imageUrlArray;
//   List<String>? discountArray;
//   List<String>? locationUrlArray;
//   List<String>? descriptionArray;

//   PriviledgeAPI(
//       {this.processStatus,
//       this.processMessage,
//       this.nameArray,
//       this.imageUrlArray,
//       this.discountArray,
//       this.locationUrlArray,
//       this.descriptionArray});

//   PriviledgeAPI.fromJson(Map<String, dynamic> json) {
//     processStatus = json['process_status'];
//     processMessage = json['process_message'];
//     nameArray = json['name_array'].cast<String>();
//     imageUrlArray = json['image_url_array'].cast<String>();
//     discountArray = json['discount_array'].cast<String>();
//     locationUrlArray = json['location_url_array'].cast<String>();
//     descriptionArray = json['description_array'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['process_status'] = this.processStatus;
//     data['process_message'] = this.processMessage;
//     data['name_array'] = this.nameArray;
//     data['image_url_array'] = this.imageUrlArray;
//     data['discount_array'] = this.discountArray;
//     data['location_url_array'] = this.locationUrlArray;
//     data['description_array'] = this.descriptionArray;
//     return data;
//   }
//     static Future<PriviledgeAPI> details() async {
//     Uri url = Uri.parse(
//         "${Webservice.rootURL}${Webservice.privilege}?nickname=${Webservice.appNickname}");
//     final request = http.MultipartRequest('POST', url);
//     String? accessCode = await UserDataRepository.getAccessCode();
//     if (accessCode != null) {
//       print('Access Code: $accessCode');
//     } else {
//       print('Access code not found');
//     }
//     request.fields
//         .addAll({'organization_id': 'csc', 'theaccesscode': '${accessCode}'});

//     http.StreamedResponse response = await request.send();
//     String responseString = await response.stream.bytesToString();
//     // print('in dobapi code ${responseString}');
//     return PriviledgeAPI.fromJson(jsonDecode(responseString));
//   }

// }



// this rividlege api code  here  want to use this to make my beow front nd dynamic
// import 'dart:async';
// import 'package:flutter/material.dart';

// class CarouselWidget extends StatefulWidget {
//   @override
//   _CarouselWidgetState createState() => _CarouselWidgetState();
// }

// class _CarouselWidgetState extends State<CarouselWidget> {
//   late PageController _pageController;
//   late Timer _timer;
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(
//       initialPage: 0,
//     );
//     _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
//       if (_currentPage < 2) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//       _pageController.animateToPage(
//         _currentPage,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeOut,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 190, // Adjust the height of the carousel as needed
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: 3, // Number of containers in the carousel
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               width: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Stack(
//                 children: [
//                   // Background Image
//                   Positioned.fill(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.asset(
//                         'assets/images/itcdemo.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   // Black Opacity Overlay
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.black
//                           .withOpacity(0.5), // Adjust opacity as needed
//                     ),
//                   ),
//                   // Content
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'The Place Name',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors
//                                         .white, // Text color on the black overlay
//                                   ),
//                                 ),
//                                 Text(
//                                   'Description or the person.',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors
//                                         .white, // Text color on the black overlay
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: IconButton(
//                                 onPressed: () {
//                                   // Add functionality for location button
//                                 },
//                                 icon: Icon(
//                                   Icons.location_on,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text(
//                               '30% OFF',
//                               style: TextStyle(
//                                 fontSize: 38, // Adjust font size as needed
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//             ),
//           );
//         },
//       ),
//     );
//   }
// }
