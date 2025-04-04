import 'package:firebase_auth/firebase_auth.dart';
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

  Future<String?> _getCompanyID() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in.");
        return null;
      }

      // Fetch user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users') // Ensure you have a Users collection
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        print("User document does not exist.");
        return null;
      }

      // Extract company ID
      String? companyId = userDoc['company_id'] as String?;
      if (companyId == null || companyId.isEmpty) {
        print("Company ID not found in user document.");
        return null;
      }

      return companyId;
    } catch (e) {
      print("Error fetching company ID: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Service Request List",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildServiceRequestList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('selectedServices')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No service requests available."));
          }

          var serviceRequests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: serviceRequests.length,
            itemBuilder: (context, index) {
              var data = serviceRequests[index].data() as Map<String, dynamic>;
              var clientName = data['client_name'] ?? 'Unknown Client';
              var brand = data['selected_vehicle'] ?? 'Unknown';
              var model = data['Vehicle_model'] ?? 'Unknown';
              var fuelType = data['fuel_type'] ?? 'Unknown';
              var vehicleNo = data['Vehicle_no'] ?? 'Unknown';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Car | $brand | $model | $fuelType | $vehicleNo",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Move service to history
                                _markAsDone(
                                    serviceRequests[index].reference, data);
                              },
                              child: Text("Done"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                              ),
                            ),
                            SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () {
                                // Navigate to client details
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsPage(serviceData: data),
                                  ),
                                );
                              },
                              child: Text("Locate Client"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _markAsDone(
      DocumentReference serviceRef, Map<String, dynamic> serviceData) async {
    try {
      // Get the current logged-in user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user logged in");
        return;
      }

      // Fetch the company ID from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users') // Make sure your Users collection has company_id
          .doc(user.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        print("User document does not exist");
        return;
      }

      String companyId =
          (userDoc.data() as Map<String, dynamic>)['company_id'] ?? '';
      if (companyId.isEmpty) {
        print("No company ID found for user");
        return;
      }

      // Move service request to service history
      await FirebaseFirestore.instance
          .collection('Company')
          .doc(companyId) // Use fetched company ID
          .collection('accepted_services')
          .add(serviceData);

      // Remove from service requests
      await serviceRef.delete();

      // Refresh UI
      setState(() {}); // Forces UI to reload and update service history
    } catch (e) {
      print("Error moving to service history: $e");
    }
  }

  Widget _buildServiceHistory() {
    return FutureBuilder<String?>(
      future: _getCompanyID(), // Fetch the company ID first
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
              child: Text("No company ID found. Please check user data."));
        }

        String companyId = snapshot.data!;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Company')
              .doc(companyId)
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
                var clientName = service['client_name'] ?? 'Unknown Client';
                var brand = service['selected_vehicle'] ?? 'Unknown';
                var model = service['Vehicle_model'] ?? 'Unknown';
                var fuelType = service['fuel_type'] ?? 'Unknown';
                var vehicleNo = service['Vehicle_no'] ?? 'Unknown';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clientName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Car | $brand | $model | $fuelType | $vehicleNo",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> serviceData;

  const DetailsPage({Key? key, required this.serviceData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Client Details")),
      body: Center(child: Text("Client location and details here.")),
    );
  }
}
