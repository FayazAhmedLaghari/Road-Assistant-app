import 'package:firebase_app/lib/User%20Side/HistoryInfo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceHistory extends StatelessWidget {
  const ServiceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF001E62), Colors.white],
              ),
            ),
            child: Stack(alignment: AlignmentDirectional.center, children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Positioned(
                top: 80,
                child: Text(
                  "History of Services",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Text(
              "Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Fetch and display requests from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No service history available"),
                  );
                }

                var services = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    var service =
                        services[index].data() as Map<String, dynamic>;

                    return buildServiceCard(
                      context,
                      service,
                      service['selected_service'] ?? "Unknown Service",
                      service['location'] ?? "Unknown Location",
                      service['timestamp'] != null
                          ? (service['timestamp'] as Timestamp)
                              .toDate()
                              .toString()
                          : "Unknown Date",
                      _getServiceIcon(service['selected_service']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Map services to their respective icons
  IconData _getServiceIcon(String? service) {
    switch (service) {
      case "Flat tire":
        return Icons.tire_repair;
      case "Towing Service":
        return Icons.local_shipping;
      case "Engine Heat":
        return Icons.warning;
      case "Battery Jump Start":
        return Icons.battery_charging_full;
      case "Engine Check":
        return Icons.settings;
      case "Key Lock":
        return Icons.vpn_key;
      default:
        return Icons.miscellaneous_services;
    }
  }
}

// Reusable Card Widget
Widget buildServiceCard(BuildContext context, Map<String, dynamic> service,
    String title, String address, String time, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF001E62),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled,
                            size: 16, color: Colors.black),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HistoryInformation(requestData: service),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001E62),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
                child: const Text(
                  "Details",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
