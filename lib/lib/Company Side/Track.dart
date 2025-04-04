import 'package:firebase_app/lib/Company%20Side/CompanyNotification.dart';
import 'package:firebase_app/lib/Company%20Side/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Track extends StatefulWidget {
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "Service Requests"),
              Tab(text: "Service History"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildServiceRequestList(),
                _buildServiceHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF001E62), Colors.white],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyNotificationsScreen(),
                  ),
                );
              },
              icon: Icon(Icons.notifications, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildServiceRequestList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Company')
            .doc("YOUR_COMPANY_ID") // Replace with your actual company ID
            .collection('accepted_services')
            // .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No service history available."));
          }

          var services = snapshot.data!.docs;

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              var service = services[index].data() as Map<String, dynamic>;
              var carNo = service['car_no'] ?? 'Unknown';
              var selectedVehicle = service['selected_vehicle'] ?? 'Unknown';
              var vehicleColor = service['Vehicle_color'] ?? 'Unknown';
              var selectedService = service['selected_service'] ?? 'Unknown';
              var vehicleNo = service['Vehicle_no'] ?? 'Unknown';
              // var timestamp = service['timestamp'] as Timestamp?;
              // String formattedDate = timestamp != null
              //     ? "${timestamp.toDate().toLocal()}"
              //     : "Unknown time";

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(carNo,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          "$selectedVehicle | $vehicleColor | $selectedService | $vehicleNo"),
                      SizedBox(height: 10),
                      // Text(formattedDate,
                      //     style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildServiceHistory() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Company')
            .doc("YOUR_COMPANY_ID") // Replace with your actual company ID
            .collection('accepted_services')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No service history available."));
          }

          var services = snapshot.data!.docs;

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              var service = services[index].data() as Map<String, dynamic>;
              var carNo = service['car_no'] ?? 'Unknown';
              var selectedVehicle = service['selected_vehicle'] ?? 'Unknown';
              var vehicleColor = service['Vehicle_color'] ?? 'Unknown';
              var selectedService = service['selected_service'] ?? 'Unknown';
              var vehicleNo = service['Vehicle_no'] ?? 'Unknown';
              var timestamp = service['timestamp'] as Timestamp?;
              String formattedDate = timestamp != null
                  ? "${timestamp.toDate().toLocal()}"
                  : "Unknown time";

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(carNo,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          "$selectedVehicle | $vehicleColor | $selectedService | $vehicleNo"),
                      SizedBox(height: 10),
                      Text(formattedDate,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
