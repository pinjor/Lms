import 'package:bjp_app/config/app_theme_data.dart';
import 'package:flutter/material.dart';

class ProfileViewingScreen extends StatelessWidget {
  final profile;

  const ProfileViewingScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemeData.lightThemeData,
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${profile.name}'),
              Text('Email: ${profile.email}'),
              Text('Mobile: ${profile.mobile}'),
              // Add any other fields you want to display
            ],
          ),
        ),
      ),
    );
  }
}
