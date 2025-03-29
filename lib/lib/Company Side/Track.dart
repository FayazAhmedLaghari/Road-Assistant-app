import 'package:firebase_app/lib/Company%20Side/CompanyNotification.dart';
import 'package:firebase_app/lib/Company%20Side/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Track extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildServiceRequestList(),
            _buildServiceHistory(),
          ],
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Service Request List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('requests') // Fetching from Firestore
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text("No service requests available."));
              }

              var serviceRequests = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: serviceRequests.length,
                itemBuilder: (context, index) {
                  var serviceData =
                      serviceRequests[index].data() as Map<String, dynamic>;

                  String selectedService =
                      serviceData['selected_service'] ?? 'Unknown Service';
                  String selectedVehicle =
                      serviceData['selected_vehicle'] ?? 'Unknown Vehicle';
                  String location =
                      serviceData['location'] ?? 'No Location Provided';
                  String contactNo =
                      serviceData['contact_no'] ?? 'No Contact Info';

                  // Convert timestamp
                  var timestamp = serviceData['timestamp'] as Timestamp?;
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
                          Text("Service: $selectedService",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text("Vehicle: $selectedVehicle"),
                          Text("Location: $location"),
                          Text("Contact: $contactNo"),
                          const SizedBox(height: 10),
                          Text("Requested At: $formattedDate",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          // Center(
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       // Handle completion action here (e.g., updating status)
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //         backgroundColor: const Color(0xFF001E62)),
                          //     child: const Text("Mark as Done",
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceHistory() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service History",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Company')
                .doc("2PEn04QtiMXkNk1h6Qe3Vk4fE2") // Use your actual company ID
                .collection('accepted_services') // Fetch accepted services
                .orderBy('timestamp', descending: true) // Sort by newest
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
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  var service = services[index].data() as Map<String, dynamic>;
                  var customerName = service['customer_name'] ?? 'Unknown';
                  var vehicleType = service['vehicle_type'] ?? 'Unknown';
                  var vehicleBrand = service['vehicle_brand'] ?? 'Unknown';
                  var vehicleModel = service['vehicle_model'] ?? 'Unknown';
                  var fuelType = service['fuel_type'] ?? 'Unknown';
                  var plateNumber = service['plate_number'] ?? 'Unknown';
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
                          Text(
                            customerName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$vehicleType | $vehicleBrand | $vehicleModel | $fuelType | $plateNumber",
                          ),
                          SizedBox(height: 10),
                          Text(
                            formattedDate,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _serviceCard({bool isRequest = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mr. Wesilewski",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Car | Toyota | Innova | Petrol | DL 01 MN 5632"),
            SizedBox(
              height: 10,
            ),
            if (isRequest)
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001E62)),
                  child: Text("Done", style: TextStyle(color: Colors.white)),
                ),
              )
            else
              Text("Tue 7 Jun 11:21 AM",
                  style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
