import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
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
          color: Colors.white, // Set the color to white
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  elevation: 5, // Set elevation for shadow effect
                  borderRadius: BorderRadius.circular(4), // Set round edges
                  child: PopupMenuButton<String>(
                    offset:
                        Offset(0, 40), // Adjust the vertical offset as needed
                    onSelected: (String value) {
                      // Handle selection of the dropdown item
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Option 1',
                        child: SizedBox(
                          width: 120, // Set the width of the PopupMenuItem
                          child: Center(child: Text('Option 1')),
                        ),
                      ),
                      PopupMenuDivider(), // Add PopupMenuDivider between options
                      PopupMenuItem<String>(
                        value: 'Option 2',
                        child: SizedBox(
                          width: 120, // Set the width of the PopupMenuItem
                          child: Center(child: Text('Option 2')),
                        ),
                      ),
                      PopupMenuDivider(), // Add PopupMenuDivider between options
                      PopupMenuItem<String>(
                        value: 'Option 3',
                        child: SizedBox(
                          width: 120, // Set the width of the PopupMenuItem
                          child: Center(child: Text('Option 3')),
                        ),
                      ),
                    ],
                    child: Container(
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        color: AppThemes
                            .getBackground(), // Set background color to white
                        borderRadius:
                            BorderRadius.circular(4), // Set round edges
                      ),
                      child: Icon(
                        Icons.filter_alt,
                        color: AppThemes.brc_textcolor,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('data'),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 85,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.red,
                          child: Center(child: Text('Block 1')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.blue,
                          child: Center(child: Text('Block 2')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.green,
                          child: Center(child: Text('Block 3')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.yellow,
                          child: Center(child: Text('Block 4')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 85,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.red,
                          child: Center(child: Text('Block 1')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.blue,
                          child: Center(child: Text('Block 2')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.green,
                          child: Center(child: Text('Block 3')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.yellow,
                          child: Center(child: Text('Block 4')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8), // Add spacing between rows
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('data'),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 85,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.red,
                          child: Center(child: Text('Block 1')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.blue,
                          child: Center(child: Text('Block 2')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.green,
                          child: Center(child: Text('Block 3')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.yellow,
                          child: Center(child: Text('Block 4')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 85,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.red,
                          child: Center(child: Text('Block 1')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.blue,
                          child: Center(child: Text('Block 2')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.green,
                          child: Center(child: Text('Block 3')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.yellow,
                          child: Center(child: Text('Block 4')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
