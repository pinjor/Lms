import 'package:flutter/material.dart';

class MissedYouSection extends StatelessWidget {
  const MissedYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We missed you, Md Omar',
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: 'Get back on track',
                  style: TextStyle(
                    color: const Color(0xFF6B21A8),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: null, // You can add TapGestureRecognizer for clickable link
                ),
                const TextSpan(
                  text: ' and achieve your goals. 5–10 minutes a day will do.',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}