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
  List<String> cities = []; // Store dynamic cities
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

  // Fetch directory data and populate the contacts and cities
  void fetchDirectory() async {
    try {
      DirectoryAPI directoryData = await DirectoryAPI.directory();
      setState(() {
        contacts = directoryData.data ?? [];
        filteredContacts.addAll(contacts);

        // // Extract unique cities dynamically from the contact list
        // cities = contacts
        //     .map((contact) => contact.city ?? '')
        //     .where((city) => city.isNotEmpty)
        //     .toSet()
        //     .toList();
        cities = contacts
            .map((member) => (member.global == '' || member.global == null)
                ? member.city ?? ''
                : '${member.global}') // Get the city of each member
            // .where((city) => city.isNotEmpty) // Filter out empty cities
            .toSet() // Remove duplicates
            .toList();
        cities.sort(); // Optional: sort cities alphabetically

        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching directory data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Filter contacts based on search query and selected city
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
            contact.city?.toLowerCase() == selectedFilter!.toLowerCase() ||
            contact.global?.toLowerCase() == selectedFilter!.toLowerCase();
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool ismillmams = Webservice.appNickname == 'millmams';
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
          if (ismillmams)
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
                  // Dynamically populate the city dropdown options
                  items: cities.map<DropdownMenuItem<String>>((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
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
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                        dataRowColor:
                            MaterialStateProperty.resolveWith((states) {
                          return states.contains(MaterialState.selected)
                              ? Colors.grey[100]
                              : null;
                        }),
                        columns: const [
                          DataColumn(
                            label: Text('No.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Name',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Class',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          filteredContacts.length,
                          (index) {
                            final contact = filteredContacts[index];
                            return DataRow(
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (contact.memberNameMale != null)
                                        Text(contact.memberNameMale!),
                                      if (contact.memberNameFemale != null)
                                        Text(contact.memberNameFemale!),
                                    ],
                                  ),
                                  onTap: !ismillmams
                                      ? () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ProfileScreen(
                                                memberId:
                                                    contact.membershipCode ??
                                                        '',
                                                gender:
                                                    contact.memberNameMale !=
                                                            null
                                                        ? 'male'
                                                        : 'female',
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                ),
                                DataCell(
                                  Text(contact.classs?? ''),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
