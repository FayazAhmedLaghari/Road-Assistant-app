import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, String>> notifications = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _setupLocalNotifications();
    _setupFirebaseMessaging();
  }

  void _setupLocalNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // Must match with the FCM channel_id if used
      'High Importance Notifications',

      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      1, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get FCM token
    String? token = await messaging.getToken();
    print("FCM Token: $token");

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message: ${message.notification?.title}");

      if (message.notification != null) {
        setState(() {
          notifications.insert(0, {
            'title': message.notification!.title ?? "New Notification",
            'body': message.notification!.body ?? "",
            'time': "Just now"
          });
        });

        // Show a local notification
        _showLocalNotification(
          message.notification!.title ?? "New Notification",
          message.notification!.body ?? "",
        );
      }
    });

    // Handle when the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("App opened from notification: ${message.notification?.title}");
        setState(() {
          notifications.insert(0, {
            'title': message.notification!.title ?? "New Notification",
            'body': message.notification!.body ?? "",
            'time': "Just now"
          });
        });
      }
    });

    // Handle when the app is in the background and opened by tapping a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: notifications.isEmpty
          ? Center(child: Text("No notifications yet"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(notification: notifications[index]);
              },
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, String> notification;

  const NotificationCard({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(notification['title']!,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(notification['body']!),
        trailing:
            Text(notification['time']!, style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
