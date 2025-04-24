import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(NotificationApp());
}

class NotificationApp extends StatefulWidget {
  @override
  _NotificationAppState createState() => _NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Ask for permission (Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'simple_channel_id',
      'Simple Notifications',
      channelDescription: 'Test notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Hello!',
      'This is your test notification.',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Notification Test")),
        body: Center(
          child: ElevatedButton(
            onPressed: showNotification,
            child: Text("Notify Me"),
          ),
        ),
      ),
    );
  }
}
