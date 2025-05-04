import 'package:bjp_app/core/constants/assets_path.dart';
import 'package:flutter/material.dart';

class FirstHomeScreenPortion extends StatelessWidget {
  const FirstHomeScreenPortion({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Dynamically calculate font sizes based on screen width
    double titleFontSize =
        screenWidth * 0.05; // Adjust the percentage for title font size
    double bodyFontSize =
        screenWidth * 0.025; // Adjust the percentage for body font size

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First Container with text and padding
        Container(
          height: screenHeight * 0.25, // Adjust height based on screen size
          width: screenWidth * 0.60, // Adjust width based on screen size
          color: Colors.cyan,
          child: Padding(
            padding: EdgeInsets.all(
              screenWidth * 0.010,
            ), // Padding relative to screen width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'পরিবর্তনে যোগ দিন',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: titleFontSize, // Dynamically adjusted font size
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'আমাদের লক্ষ্য একটি এমন সমাজ গঠন করা যেখানে '
                  'প্রতিটি মানুষ সমান সুযোগ এবং মর্যাদা পাবে। আমরা বিশ্বাস করি যে '
                  'সুশাসন ও জনগণের সক্রিয় অংশগ্রহণ ছাড়া প্রকৃত উন্নয়ন সম্ভব নয়।',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: bodyFontSize, // Dynamically adjusted font size
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'ন্যায়বিচার ও সমানাধিকারের ওপর ভিত্তি করে আমরা একটি ন্যায়সংগত '
                  'সমাজ বিনির্মাণে প্রতিশ্রুতিবদ্ধ, যেখানে প্রত্যেকে স্বাধীনভাবে নিজের মত প্রকাশ '
                  'করতে পারবে এবং সঠিক অধিকার ভোগ করতে সক্ষম হবে।',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: bodyFontSize, // Dynamically adjusted font size
                  ),
                ),
              ],
            ),
          ),
        ),

        // Image with flexible size
        Flexible(
          child: Image.asset(
            AssetsPath.imagetwo,
            height: screenHeight * 0.25, // Dynamically adjust height
            width: screenWidth * 0.4, // Dynamically adjust width
            fit: BoxFit.cover, // Ensures the image scales nicely
          ),
        ),
      ],
    );
  }
}
