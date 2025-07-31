import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/directory.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/profile_screen_v2.dart';

class Directory extends StatefulWidget {
  const Directory({Key? key}) : super(key: key);

  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  late TextEditingController _searchController;
  List<Data> contacts = [];
  List<Data> filteredContacts = [];
  bool _isLoading = true; // Loading state
  String? selectedFilter; // For dropdown filter

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
        _isLoading = false; // Data loaded
      });
    } catch (e) {
      print('Error fetching directory data: $e');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  void filterContacts(String query) {
    setState(() {
      // Filter contacts based on the search query and selected city
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
                hintText: 'Search contacts',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          if (isMilleniumMams)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select City'),
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
              ),
            ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
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

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: memberDetails.map((member) {
                          return GestureDetector(
                            onTap: () {
                              if (!isMilleniumMams) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ProfileScreenV2(
                                    memberId: contact.membershipCode ?? '',
                                    gender: member['gender']!,
                                  ),
                                ));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  if (isMilleniumMams)
                                    Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        member['imageUrl'] ?? '',
                                      ),
                                      radius: 25,
                                    ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      member['name']!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
