
import 'package:bjp_app/features/features/presentation/screens/learning_card.dart';
import 'package:flutter/material.dart';

class LearningSection extends StatelessWidget {
  const LearningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Let's start learning",
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: const [
                  LearningCard(
                    videoTitle: 'First Year MBBS Course List (Phase 1)',
                    description: '1. What is Anatomy? Basic discussion on Anatomy.',
                    thumbnailUrl:
                    'https://storage.googleapis.com/a1aa/image/75e583bf-323b-4060-3cb0-1fd1b3a7ec25.jpg',
                  ),
                  SizedBox(width: 16),
                  LearningCard(
                    videoTitle: 'First Year MBBS Course List (Phase 1)',
                    description: '1. What is Physiology? Describe Physiology',
                    thumbnailUrl:
                    'https://storage.googleapis.com/a1aa/image/75e583bf-323b-4060-3cb0-1fd1b3a7ec25.jpg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
