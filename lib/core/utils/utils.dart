// used for logging value in the terminal
import 'package:bjp_app/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final lgr = Logger();

void showMessageToUser({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.center)),
    );
}

Future<void> showErrorDialog(
  BuildContext context, {
  required String errorMessage,
  required String title,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: Text('ঠিক আছে'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss dialog
            },
          ),
        ],
      );
    },
  );
}

void showLogoutDialog({
  required BuildContext context,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'লগআউট',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.themeColor),
        ),

        content: Text('আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('বাতিল', style: TextStyle(color: AppColors.themeColor)),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text('লগআউট', style: TextStyle(color: AppColors.themeColor)),
          ),
        ],
      );
    },
  );
}
