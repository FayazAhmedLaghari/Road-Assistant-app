import 'package:firebase_app/lib/Company%20Side/Tabbar.dart';
import 'package:firebase_app/lib/Company%20Side/Track.dart';
import 'package:firebase_app/lib/HelpSupportScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CompanyNotification.dart';
import '../User Side/Register.dart';

class CompanyDrawer extends StatelessWidget {
  const CompanyDrawer({super.key});

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
              decoration: const BoxDecoration(
                color: Color(0xFF001E62),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/profile_image.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'jack',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'jack@yupmail.com',
                    style: TextStyle(
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
                    iconPath: 'assets/dashboard.png',
                    title: "Dashboard",
                    destination: CompanyNotificationsScreen(),
                  ),

                  // Add/Edit Services - Opens Dialog Instead of New Screen
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/home2.jpg', width: 24),
                    ),
                    title: Text(
                      "Add/Edit Services",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      _showAddServiceDialog(context); // ✅ Opens Add Dialog
                    },
                  ),
                  buildMenuItem(
                    context,
                    iconPath: 'assets/service_request.png',
                    title: "Service Requests",
                    destination: Hometab(),
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

  // ✅ Fix 1: Re-Adding `buildMenuItem` Function
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

  // ✅ Fix 2: Re-Adding `_showLogoutDialog`
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
                Navigator.of(context).pop();
              },
              child: const Text("Cancel",
                  style: TextStyle(color: Color(0xFF001E62))),
            ),
            TextButton(
              onPressed: () {
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

  void _showAddServiceDialog(BuildContext context) {
    TextEditingController customerController = TextEditingController();
    TextEditingController vehicleTypeController = TextEditingController();
    TextEditingController vehicleBrandController = TextEditingController();
    TextEditingController vehicleModelController = TextEditingController();
    TextEditingController fuelTypeController = TextEditingController();
    TextEditingController plateNumberController = TextEditingController();

    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String companyId = "2PEn04QtiMXkNk1h6Qe3Vk4fE2"; // 🔹 Replace if needed

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Service"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: customerController,
                decoration: InputDecoration(labelText: "Customer Name"),
              ),
              TextField(
                controller: vehicleTypeController,
                decoration: InputDecoration(labelText: "Vehicle Type"),
              ),
              TextField(
                controller: vehicleBrandController,
                decoration: InputDecoration(labelText: "Vehicle Brand"),
              ),
              TextField(
                controller: vehicleModelController,
                decoration: InputDecoration(labelText: "Vehicle Model"),
              ),
              TextField(
                controller: fuelTypeController,
                decoration: InputDecoration(labelText: "Fuel Type"),
              ),
              TextField(
                controller: plateNumberController,
                decoration: InputDecoration(labelText: "Plate Number"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _addNewService(
                  _firestore,
                  companyId,
                  customerController.text,
                  vehicleTypeController.text,
                  vehicleBrandController.text,
                  vehicleModelController.text,
                  fuelTypeController.text,
                  plateNumberController.text,
                );
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _addNewService(
    FirebaseFirestore firestore,
    String companyId,
    String customerName,
    String vehicleType,
    String vehicleBrand,
    String vehicleModel,
    String fuelType,
    String plateNumber,
  ) async {
    if (customerName.isEmpty ||
        vehicleType.isEmpty ||
        vehicleBrand.isEmpty ||
        vehicleModel.isEmpty ||
        fuelType.isEmpty ||
        plateNumber.isEmpty) return;

    await firestore
        .collection('Company')
        .doc(companyId)
        .collection('done_services')
        .add({
      'customer_name': customerName,
      'vehicle_type': vehicleType,
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'fuel_type': fuelType,
      'plate_number': plateNumber,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print("✅ Service Added Successfully!");
  }
}
