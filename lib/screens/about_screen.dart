import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: AppThemes.getBackground(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/mmmain_logo.png', // Replace with actual image URL or asset path
                  height: 120,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Millennium Mams',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppThemes.getBackground(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Founded in 1993 by Mr. Bishnu Dhanuka and Mr. Sanjay Bhuwania, Millennium Mams has been a trailblazer in empowering women through financial literacy. With chapters in Kolkata, Bangalore, and Mumbai, and a presence in over 22 countries and 40 cities, the organization has a global reach.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "Mission & Vision",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.getBackground(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Millennium Mams is dedicated to enhancing women's financial acumen through comprehensive educational programs, adhering to Warren Buffett's timeless investment principles, and teaching the art of long-term investing and financial planning.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "Our Global Impact",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.getBackground(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Till date, Millennium Mams has empowered over 10,000 women worldwide. The organization offers offline classes in Kolkata and online classes for members in all other locations. The curriculum imparts financial knowledge through various methods, including studying current affairs and business dailies, analyzing balance sheets, participating in annual general meetings (AGMs), tracking global economic trends, and conducting plant visits.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "Empowering Women",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.getBackground(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "These programs aim to build a community of financially independent women who can take charge of their financial futures. Many enterprising women have become successful entrepreneurs and long-term investors with robust portfolios.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "Achievements",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.getBackground(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "A significant milestone was the delegation's participation in the Berkshire Hathaway Annual General Meeting in Omaha, Nebraska, highlighting Millennium Mams as India's largest group of women investors and earning recognition in The Sunday Times Magazine, London.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "Conclusion",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.getBackground(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Millennium Mams continues to inspire and educate thousands of women globally, promoting financial independence and fostering a community of empowered women worldwide.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Add functionality here if needed
              //     },
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 24, vertical: 12),
              //       backgroundColor: AppThemes.getBackground(),
              //     ),
              //     child: const Text(
              //       'Learn More',
              //       style: TextStyle(fontSize: 18),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
