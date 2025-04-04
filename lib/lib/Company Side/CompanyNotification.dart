import 'package:firebase_app/lib/Company%20Side/Drawer.dart';
import 'package:flutter/material.dart';

class CompanyNotificationsScreen extends StatelessWidget {
  const CompanyNotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CompanyDrawer(),
      body: Column(
        children: [
          // Gradient Header
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Color(0xFF001E62), Colors.white],
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              actions: const [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_placeholder.jpg'),
                ),
                SizedBox(width: 10),
              ],
            ),
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

class NotificationCard extends StatelessWidget {
  final Map<String, String> notification;

  const NotificationCard({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profile_placeholder.jpg'),
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bid Accepted",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your bid of \${notification['amount']} for assignment ${notification['assignment']} has been accepted.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              notification['time']!,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, String>> notifications = [
  {'amount': '\$44', 'assignment': 'wait4me', 'time': '56 mins ago'},
  {'amount': '\$66', 'assignment': 'testnew', 'time': '50 mins ago'},
  {'amount': '\$88', 'assignment': 'xxxxx', 'time': '1 hr ago'},
  {'amount': '\$22', 'assignment': 'qqqqq', 'time': '1 hr ago'},
  {'amount': '\$27.5', 'assignment': 'ooooo', 'time': '2 hr ago'},
];
