import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../User Side/Notification.dart';

class CompanyNotificationsScreen extends StatefulWidget {
  const CompanyNotificationsScreen({super.key});

  @override
  _CompanyNotificationsScreenState createState() =>
      _CompanyNotificationsScreenState();
}

class _CompanyNotificationsScreenState
    extends State<CompanyNotificationsScreen> {
  final List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notifications.insert(0, {
          'amount': 'N/A',
          'assignment': message.notification?.title ?? 'New Notification',
          'time': 'Just now',
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          AppBar(
            title: const Text("Notifications"),
            backgroundColor: Colors.blue,
            centerTitle: true,
          ),
          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(notification: notifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
