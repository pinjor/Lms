import 'package:bjp_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/ui/splash_screen.dart';
import 'features/local_notification/local_notification.dart';

void main() {
  runApp(ProviderScope(child: SplashScreenWrapper()));
}

Future<void> initializeNotifications(GoRouter router) async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload == 'chat') {
        // Navigate to Chat using GoRouter
        router.push(
          '/chat',
          extra: {
            'userInfo': {
              'id': '123',
              'name': 'John Doe',
              // other fields...
            },
            'isChat': true,
          },
        );
      }
    },
  );
}

bool _notificationsInitialized = false;

Future<void> initializeNotificationsOnce(GoRouter router) async {
  if (_notificationsInitialized) return;
  _notificationsInitialized = true;
  await initializeNotifications(router);
}

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
