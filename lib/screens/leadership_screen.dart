import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/council_members.dart'; // Ensure the path is correct
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure the path is correct

class LeadershipScreen extends StatefulWidget {
  const LeadershipScreen({super.key});

  @override
  _LeadershipScreenState createState() => _LeadershipScreenState();
}

class _LeadershipScreenState extends State<LeadershipScreen> {
  String? selectedCategory;
  String? selectedCity;
  List<Data> allMembers = [];
  List<String> categories = [];
  List<String> cities = [];
  bool isLoadingFilters = true;
  bool isLoadingMembers = true;

  @override
  void initState() {
    super.initState();
    _fetchMembers(); // Fetch members and filters
  }

  Future<void> _fetchMembers() async {
    setState(() {
      isLoadingMembers = true;
    });
    try {
      CouncilAPI response = await CouncilAPI.list(); // Fetch council members

      // Get the list of all members
      allMembers = response.data ?? [];

      // Populate filters (categories or cities) dynamically based on members
      _populateFilters(allMembers);

      setState(() {
        isLoadingFilters = false; // Filters and members are now loaded
      });
    } catch (e) {
      print('Error fetching members: $e');
    } finally {
      setState(() {
        isLoadingMembers = false;
      });
    }
  }

  void _populateFilters(List<Data> members) {
    if (Webservice.appNickname == 'madhuban') {
      categories = members
          .map((member) =>
              member.category ?? '') // Get the category of each member
          .where(
              (category) => category.isNotEmpty) // Filter out empty categories
          .toSet() // Remove duplicates
          .toList();
      if (categories.isNotEmpty) {
        selectedCategory = categories.first; // Default selected category
      }
    } else if (Webservice.appNickname == 'millmams') {
      cities = members
          .map((member) => (member.global == '' || member.global == null)
              ? member.city ?? ''
              : '${member.global}') // Get the city of each member
          // .where((city) => city.isNotEmpty) // Filter out empty cities
          .toSet() // Remove duplicates
          .toList();
      if (cities.isNotEmpty) {
        selectedCity = cities.first; // Default selected city
      }
    }
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
          'Leadership',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppThemes.brc_textcolor),
        ),
      ),
      body: isLoadingFilters
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loader while filters are loading
          : Column(
              children: [
                if (Webservice.appNickname == 'madhuban' &&
                    categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                if (Webservice.appNickname == 'millmams' && cities.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedCity,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue!;
                        });
                      },
                      items:
                          cities.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                Expanded(
                  child: isLoadingMembers
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Show loader while members are loading
                      : _buildMembersList(),
                ),
              ],
            ),
    );
  }

  Widget _buildMembersList() {
    // Filter members based on the selected category or city
    final filteredMembers = Webservice.appNickname == 'madhuban'
        ? allMembers
            .where((member) => member.category == selectedCategory)
            .toList()
        : Webservice.appNickname == 'millmams'
            ? allMembers
                .where((member) => (member.city == selectedCity ||
                    member.global == selectedCity))
                .toList()
            : allMembers;

    if (filteredMembers.isEmpty) {
      return const Center(child: Text('No members in this category or city'));
    }

    return ListView.builder(
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        return DepartmentInfo(
          designation: member.designation ?? '',
          name: member.name ?? '',
          phone: member.phone ?? '',
          email: member.email ?? '',
          member_image: member.member_image ?? '',
        );
      },
    );
  }
}

class DepartmentInfo extends StatelessWidget {
  // ignore: use_super_parameters
  const DepartmentInfo({
    Key? key,
    required this.designation,
    required this.name,
    required this.phone,
    required this.email,
    required this.member_image,
  }) : super(key: key);

  final String designation;
  final String name;
  final String phone;
  final String email;
  final String member_image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(
              0.3), // Replace with AppThemes.getBackground().withOpacity(0.3)
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              member_image.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(member_image),
                      radius: 24,
                    )
                  : CircleAvatar(
                      backgroundColor: AppThemes.getLightColor(),
                      radius: 24,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              const SizedBox(
                  width: 16), // Add some space between avatar and text
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors
                            .black, // Replace with AppThemes.brc_spotsbooking_hint_text
                      ),
                    ),
                    const SizedBox(
                        height:
                            4), // Add some space between name and designation
                    Text(
                      designation,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors
                            .black, // Replace with AppThemes.brc_spotsbooking_hint_text
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.call),
                color: AppThemes.getBackground(),
                onPressed: () async {
                  final String phoneNumber = phone;
                  if (phoneNumber.isNotEmpty) {
                    final Uri url = Uri.parse('tel:$phoneNumber');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      // Error handling if the phone app can't be launched
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot launch phone dialer'),
                        ),
                      );
                    }
                  } else {
                    // Inform the user that there is no phone number available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No phone number available'),
                      ),
                    );
                  }
                },
              ),
              if (Webservice.appNickname != 'madhuban')
                IconButton(
                  icon: const Icon(Icons.mail),
                  color: AppThemes.getBackground(),
                  onPressed: () async {
                    final String mail = email;
                    if (mail.isNotEmpty) {
                      final Uri url = Uri.parse('mailto:$mail');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        // Error handling if the mail app can't be launched
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot launch mail'),
                          ),
                        );
                      }
                    } else {
                      // Inform the user that there is no email available
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No email available'),
                        ),
                      );
                    }
                  },
                ),
              //  if (Webservice.appNickname != 'madhuban')
              IconButton(
                icon: Image.asset(
                  'assets/images/wpicon.webp',
                  width: 24.0, // Adjust the width as needed
                  height: 24.0, // Adjust the height as needed
                ),
                onPressed: () async {
                  final String phoneNumber = phone.trim();
                  if (phoneNumber.isNotEmpty) {
                    final Uri url = Uri.parse("https://wa.me/$phoneNumber");

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      // Error handling if WhatsApp can't be launched
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot launch WhatsApp'),
                        ),
                      );
                    }
                  } else {
                    // Inform the user that there is no phone number available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No phone number available'),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
