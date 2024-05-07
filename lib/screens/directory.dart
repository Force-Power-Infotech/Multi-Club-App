import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/directory.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/profile_screen.dart';

// Import your DirectoryAPI here if not imported already

class Directory extends StatefulWidget {
  const Directory({Key? key}) : super(key: key);

  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  late TextEditingController _searchController;
  List<String> contacts = [];
  List<String> memberImageUrlArray = [];
  List<String> filteredContacts = []; // New list to store filtered contacts
  List<String> memberIdArray = []; // New list to store filtered contacts

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
      DirectoryAPI directoryData =
          await DirectoryAPI.directory('eventid', 'attending_status');

      setState(() {
        contacts = directoryData.memberNameArray ?? [];
        memberImageUrlArray = directoryData.memberImageUrlArray ?? [];
        memberIdArray = directoryData.memberIdArray ?? [];
        filteredContacts.addAll(contacts);
      });
    } catch (e) {
      print('Error fetching directory data: $e');
    }
  }

  void filterContacts(String query) {
    setState(() {
      // Filter contacts based on the search query
      filteredContacts = contacts
          .where(
              (contact) => contact.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
              onChanged: filterContacts, // Call filterContacts on text change
              decoration: InputDecoration(
                hintText: 'Search contacts',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Add onPressed action for the helpdesk icon
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        memberId: memberIdArray[index],
                      ),
                    ));
                    print(memberIdArray[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(memberImageUrlArray[index]),
                          radius: 25,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          filteredContacts[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
