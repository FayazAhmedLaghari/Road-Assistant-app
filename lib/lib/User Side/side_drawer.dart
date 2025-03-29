import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Company Side/setting_screen.dart';
import '../HelpSupportScreen.dart';
import 'Client_Issue.dart';
import 'HistoryService.dart';
import 'Notification.dart';
import 'Register.dart';
import 'Request/RequestService.dart';
import 'home_screen.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  String _userName = "Loading...";
  String _userEmail = "Loading...";
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? "No Name";
          _userEmail = user.email ?? "No Email";
          _userImageUrl = userDoc['imageUrl'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF001E62), // Dark blue background
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(color: Color(0xFF001E62)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: _userImageUrl != null
                        ? NetworkImage(_userImageUrl!)
                        : null,
                    child: _userImageUrl == null
                        ? const Icon(Icons.person,
                            size: 50, color: Color(0xFF001E62))
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _userEmail,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items Section
            Expanded(
              child: ListView(
                children: [
                  buildMenuItem(
                    context,
                    icon: Icons.dashboard,
                    title: "Dashboard",
                    destination: HomeScreen(),
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.location_on,
                    title: "Find Nearby Companies",
                    destination: RequestServiceScreen(),
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.build,
                    title: "History of Service",
                    destination: ServiceHistory(),
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.notifications,
                    title: "Notifications",
                    destination: NotificationsScreen(),
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.person,
                    title: "Account Settings",
                    destination: SettingScreen(),
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    destination: HelpSupportScreen(),
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: "Client Issue",
                    destination: ClientIssueForm(),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.logout, color: Color(0xFF001E62)),
                    ),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(child: Text("Logout")),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0xFF001E62)),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: const Text("Yes, Logout",
                  style: TextStyle(color: Color(0xFF001E62))),
            ),
          ],
        );
      },
    );
  }

  Widget buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: const Color(0xFF001E62)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
