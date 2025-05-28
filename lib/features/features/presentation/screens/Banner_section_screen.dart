import 'package:flutter/material.dart';

class BannerSectionScreen extends StatefulWidget {
  const BannerSectionScreen({super.key});

  @override
  State<BannerSectionScreen> createState() => _BannerSectionScreenState();
}

class _BannerSectionScreenState extends State<BannerSectionScreen> {
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              images[currentIndex],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 360,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey.shade700,
                  elevation: 2,
                  fixedSize: const Size(36, 36),
                ),
                onPressed: prevImage,
                child: const Icon(Icons.chevron_left),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey.shade700,
                  elevation: 2,
                  fixedSize: const Size(36, 36),
                ),
                onPressed: nextImage,
                child: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}