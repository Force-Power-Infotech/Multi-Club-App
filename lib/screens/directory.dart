import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/directory.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Directory extends StatefulWidget {
  const Directory({Key? key}) : super(key: key);

  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  late TextEditingController _searchController;
  List<Data> contacts = [];
  List<Data> filteredContacts = [];
  bool _isLoading = true;
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchDirectory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchDirectory() async {
    try {
      DirectoryAPI directoryData = await DirectoryAPI.directory();
      setState(() {
        contacts = directoryData.data ?? [];
        filteredContacts.addAll(contacts);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching directory data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void filterContacts(String query) {
    setState(() {
      filteredContacts = contacts.where((contact) {
        bool matchesQuery = (contact.memberNameMale
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (contact.memberNameFemale
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false);
        bool matchesFilter = selectedFilter == null ||
            contact.city?.toLowerCase() == selectedFilter!.toLowerCase();
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMilleniumMams = Webservice.appNickname == 'milleniumMams';
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
          'Directory',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppThemes.brc_textcolor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: filterContacts,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search contacts',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          filterContacts('');
                        },
                      )
                    : null,
                isDense: true,
              ),
            ),
          ),
          if (isMilleniumMams)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Select Chapter'),
                  value: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value;
                      filterContacts(_searchController.text);
                    });
                  },
                  items: <String>['Kolkata', 'Mumbai', 'Bangalore']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.orange))
                : ListView.builder(
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      final memberDetails = isMilleniumMams
                          ? [
                              if (contact.memberNameFemale != null)
                                {
                                  'name': contact.memberNameFemale!,
                                  'gender': 'female',
                                },
                            ]
                          : [
                              if (contact.memberNameMale != null)
                                {
                                  'name': contact.memberNameMale!,
                                  'imageUrl': contact.imageURLmale ?? '',
                                  'gender': 'male',
                                },
                              if (contact.memberNameFemale != null &&
                                  contact.memberNameFemale!.isNotEmpty)
                                {
                                  'name': contact.memberNameFemale!,
                                  'imageUrl': contact.imageURLfemale ?? '',
                                  'gender': 'female',
                                },
                            ];

                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: memberDetails.map((member) {
                              return GestureDetector(
                                onTap: () {
                                  if (!isMilleniumMams) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => ProfileScreen(
                                                  memberId:
                                                      contact.membershipCode ??
                                                          '',
                                                  gender: member['gender']!,
                                                )));
                                  }
                                },
                                child: Row(
                                  children: [
                                    if (!isMilleniumMams)
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          member['imageUrl'] ?? '',
                                        ),
                                        radius: 30,
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member['name']!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 4),
                                          if (contact.city != null)
                                            Text(
                                              contact.city!,
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
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:multi_club_app/bases/api/directory.dart';
// import 'package:multi_club_app/bases/themes.dart';
// import 'package:multi_club_app/screens/profile_screen.dart';

// // Import your DirectoryAPI here if not imported already

// class Directory extends StatefulWidget {
//   const Directory({Key? key}) : super(key: key);

//   @override
//   _DirectoryState createState() => _DirectoryState();
// }

// class _DirectoryState extends State<Directory> {
//   late TextEditingController _searchController;
//   List<String> contacts = [];
//   List<String> memberImageUrlArray = [];
//   List<String> filteredContacts = []; // New list to store filtered contacts
//   List<String> memberIdArray = []; // New list to store filtered contacts

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     fetchDirectory();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void fetchDirectory() async {
//     try {
//       DirectoryAPI directoryData =
//           await DirectoryAPI.directory('eventid', 'attending_status');

//       setState(() {
//         contacts = directoryData.memberNameArray ?? [];
//         memberImageUrlArray = directoryData.memberImageUrlArray ?? [];
//         memberIdArray = directoryData.memberIdArray ?? [];
//         filteredContacts.addAll(contacts);
//       });
//     } catch (e) {
//       print('Error fetching directory data: $e');
//     }
//   }

//   void filterContacts(String query) {
//     setState(() {
//       // Filter contacts based on the search query
//       filteredContacts = contacts
//           .where(
//               (contact) => contact.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             color: AppThemes.brc_textcolor,
//           ),
//         ),
//         backgroundColor: AppThemes.getBackground(),
//         title: const Text(
//           'Directory',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: AppThemes.brc_textcolor,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: filterContacts, // Call filterContacts on text change
//               decoration: InputDecoration(
//                 hintText: 'Search contacts',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredContacts.length,
//               itemBuilder: (context, index) {
//                 // Get the index from the filtered list
//                 int originalIndex = contacts.indexOf(filteredContacts[index]);
//                 // Ensure the index is valid
//                 if (originalIndex >= 0 &&
//                     originalIndex < memberImageUrlArray.length) {
//                   return GestureDetector(
//                     onTap: () {
//                       // Open the profile screen with the correct memberId
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (_) => ProfileScreen(
//                           memberId: memberIdArray[originalIndex],
//                         ),
//                       ));
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 4),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundImage: NetworkImage(
//                               memberImageUrlArray[originalIndex],
//                             ),
//                             radius: 25,
//                           ),
//                           const SizedBox(width: 16),
//                           Text(
//                             filteredContacts[index],
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else {
//                   // Return an empty widget if index is out of bounds
//                   return SizedBox.shrink();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }