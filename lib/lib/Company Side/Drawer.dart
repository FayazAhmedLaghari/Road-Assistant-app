import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'CompanyNotification.dart';
import '../User Side/Register.dart';
import 'ServiceProvide.dart';
import 'Tabbar.dart';
import 'Track.dart';
import '../HelpSupportScreen.dart';

class CompanyDrawer extends StatefulWidget {
  const CompanyDrawer({super.key});

  @override
  _CompanyDrawerState createState() => _CompanyDrawerState();
}

class _CompanyDrawerState extends State<CompanyDrawer> {
  String companyName = "Loading...";
  String companyEmail = "Loading...";
  String profileImage = ""; // Default is empty, fallback to placeholder

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  Future<void> _fetchCompanyData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Company')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          companyName = doc['name'] ?? "No Name";
          companyEmail = user.email ?? "No Email";
          profileImage = doc['imageUrl'] ?? ""; // Cloudinary Image URL
        });
      }
    } catch (e) {
      print("Error fetching company data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF001E62), // Dark blue background
        child: Column(
          children: [
            // 🔹 **Header Section**
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF001E62),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage(profileImage)
                        : const AssetImage('assets/profile_image.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    companyName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    companyEmail,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 **Menu Items Section**
            Expanded(
              child: ListView(
                children: [
                  buildMenuItem(
                    context,
                    iconPath: 'assets/dashboard.png',
                    title: "Dashboard",
                    destination: CompanyNotificationsScreen(),
                  ),
                  buildMenuItem(
                    context,
                    iconPath: 'assets/service_request.png',
                    title: "Service Requests",
                    destination: ServiceProvide(),
                  ),
                  buildMenuItem(
                    context,
                    iconPath: 'assets/client_issue.png',
                    title: "Client Issue Details",
                    destination: Hometab(),
                  ),
                  buildMenuItem(
                    context,
                    iconPath: 'assets/manage_loc.png',
                    title: "Manage Locations",
                    destination: Hometab(),
                  ),
                  buildMenuItem(
                    context,
                    iconPath: 'assets/service_his.png',
                    title: "Service History",
                    destination: Track(),
                  ),
                  buildMenuItem(
                    context,
                    iconPath: 'assets/notification2.png',
                    title: "Notifications",
                    destination: CompanyNotificationsScreen(),
                  ),
                  buildMenuItem(
                    context,
                    iconPath: 'assets/account_set.png',
                    title: "Account Settings",
                    destination: Hometab(),
                  ),
                  buildMenuItem(
                    context,
                    iconPath: 'assets/HelpSupport.png',
                    title: "Help & Support",
                    destination: HelpSupportScreen(),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/log-out.png', width: 24),
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

  // ✅ **Reusable Method for Menu Items**
  Widget buildMenuItem(
    BuildContext context, {
    required String iconPath,
    required String title,
    required Widget destination,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset(iconPath, width: 24),
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

  // ✅ **Logout Confirmation Dialog**
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel",
                  style: TextStyle(color: Color(0xFF001E62))),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
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
}
