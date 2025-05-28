import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class contact_information_screen extends StatelessWidget {
  const contact_information_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'যোগাযোগের তথ্য',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'ঢাকা, বাংলাদেশ।',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.blue),
                        SizedBox(width: 14),
                        Text(
                          '০২-XXX-XXX',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.email_outlined, color: Colors.blue),
                        SizedBox(width: 14),
                        Text(
                          'info@bjp.org',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 85),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.video_collection_rounded,
                          color: Colors.blue,
                        ),
                        TextButton(
                          onPressed: () async {
                            final url = Uri.parse(
                              'https://www.youtube.com/@ArpPartho',
                            );
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: const Text(
                            'ইউটিউব',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.facebook_outlined,
                          color: Colors.blue,
                        ), // Add spacing between icon and button
                        TextButton(
                          onPressed: () async {
                            final url = Uri.parse(
                              'https://www.facebook.com/Andaleeve.Rahman',
                            );
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: const Text(
                            'ফেসবুক',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.account_box, color: Colors.blue),

                        TextButton(
                          onPressed: () async {
                            final url = Uri.parse(
                              'https://www.instagram.com/andaleeve_rahman_partho',
                            );
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: const Text(
                            'ইনস্টাগ্রাম',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
