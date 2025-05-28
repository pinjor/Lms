
import 'package:bjp_app/features/features/presentation/screens/Banner_section_screen.dart';
import 'package:bjp_app/features/features/presentation/screens/Missed_you_section.dart';
import 'package:bjp_app/features/features/presentation/screens/learning_section.dart';
import 'package:bjp_app/features/my_learning/presentation/screens/my_learning.dart';
import 'package:flutter/material.dart';

class WelcomeSectionScreen extends StatefulWidget {
  const WelcomeSectionScreen({super.key});

  @override
  State<WelcomeSectionScreen> createState() => _WelcomeSectionScreenState();
}

class _WelcomeSectionScreenState extends State<WelcomeSectionScreen> {


  final List<String> images = [
    'https://storage.googleapis.com/a1aa/image/1cba7c42-8f38-42d7-df81-59da76d2b56a.jpg',
    // You can add more images here if needed
  ];
  int currentIndex = 0;

  void prevImage() {
    setState(() {
      currentIndex = (currentIndex - 1) % images.length;
      if (currentIndex < 0) currentIndex = images.length - 1;
    });
  }

  void nextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % images.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Navbar(),
          ),
          Container(

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // vertical align center
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'MF',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back, Md Omar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Add occupation and interests',
                          style: TextStyle(
                            color: Color(0xFF6B21A8), // purple-700
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          BannerSectionScreen(),
          MissedYouSection(),
          LearningSection(),
      
        ],
      ),
    );


  }
}
