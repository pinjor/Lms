import 'package:bjp_app/config/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData get lightThemeData {
    return ThemeData(
      colorSchemeSeed: AppColors.themeColor,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.themeColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        //elevation: 3,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28.0,
          letterSpacing: 1.7,
          color: Colors.black,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
          letterSpacing: 0.7,
          color: Colors.grey,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //labelStyle: 'Email Address',
        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.themeColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.themeColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.themeColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.themeColor,
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.themeColor),
      ),
    );
  }
}
