import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/directory.dart';
import 'package:multi_club_app/bases/themes.dart';

// Import your DirectoryAPI here if not imported already

class Directory extends StatefulWidget {
  const Directory({Key? key}) : super(key: key);

  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  late TextEditingController _searchController; // Declare TextEditingController

  List<String> contacts = []; // Initialize contacts list
  List<String> memberImageUrlArray = []; // Initialize contacts list

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(); // Initialize TextEditingController
    fetchDirectory(); // Call the method to fetch directory data when the widget initializes
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the TextEditingController
    super.dispose();
  }

  void fetchDirectory() async {
    try {
      // Call the directory API to get the data
      DirectoryAPI directoryData =
          await DirectoryAPI.directory('eventid', 'attending_status');

      // Update the contacts list with the fetched member names
      setState(() {
        contacts = directoryData.memberNameArray ?? [];

        // Update the memberImageUrlArray with the fetched image URLs
        memberImageUrlArray = directoryData.memberImageUrlArray ?? [];
      });
    } catch (e) {
      print('Error fetching directory data: $e');
      // Handle error if any
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search contacts',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(memberImageUrlArray[
                          index]), // Use NetworkImage to load the image from URL
                      radius: 25,
                    ),
                    SizedBox(width: 16),
                    Text(
                      contacts[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
