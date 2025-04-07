import 'package:firebase_app/lib/Company%20Side/CompanyNotification.dart';
import 'package:firebase_app/lib/Company%20Side/Drawer.dart';
import 'package:firebase_app/lib/Company%20Side/client_issue_details.dart';
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
                _buildServiceHistoryList(),
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
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompanyNotificationsScreen(),
                ),
              );
            },
          ),
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
            .doc("YOUR_COMPANY_ID") // Replace with actual company ID
            .collection('service_requests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No service requests available."));
          }

          var filtered = snapshot.data!.docs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['status'] != 'Completed'; // Filter out completed requests
          }).toList();

          if (filtered.isEmpty) {
            return Center(child: Text("No service requests available."));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              var doc = filtered[index];
              var data = doc.data() as Map<String, dynamic>;

              var car_no = data['car_no'] ?? 'Unknown';
              var car_color = data['car_color'] ?? 'Unknown';
              var selected_service = data['selected_service'] ?? 'Unknown';
              var selected_vehicle = data['selected_vehicle'] ?? 'Unknown';
              var user_id = data['user_id'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users') // Fetch user data from 'users' collection
                    .doc(user_id) // Use the user_id from the service request
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return SizedBox.shrink(); // Simply skip this item if user data doesn't exist
                  }

                  var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  var user_name = userData['name'] ?? 'Unknown User'; // Assuming 'name' field in 'users' collection

                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user_name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                            "$selected_vehicle |  $selected_service | $car_no | $car_color",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // Mark the request as completed and move it to service history
                                  await FirebaseFirestore.instance
                                      .collection('Company')
                                      .doc("YOUR_COMPANY_ID")
                                      .collection('service_requests')
                                      .doc(doc.id)
                                      .update({
                                    'status': 'Completed',
                                    'completed_at': Timestamp.now(),
                                  });

                                  // Move it to service history collection (optional, but good for archiving)
                                  await FirebaseFirestore.instance
                                      .collection('Company')
                                      .doc("YOUR_COMPANY_ID")
                                      .collection('service_history')
                                      .add({
                                    'car_no': data['car_no'],
                                    'selected_vehicle': data['selected_vehicle'],
                                    'car_color': data['car_color'],
                                    'selected_service': data['selected_service'],
                                    'status': 'Completed',
                                    'timestamp': Timestamp.now(),
                                    'completed_at': Timestamp.now(),
                                  });

                                  // Remove the request from the service requests tab
                                  await FirebaseFirestore.instance
                                      .collection('Company')
                                      .doc("YOUR_COMPANY_ID")
                                      .collection('service_requests')
                                      .doc(doc.id)
                                      .delete();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Request marked as completed")),
                                  );

                                  setState(() {}); // Refresh the UI after the update
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF001E62)),
                                child: Text("Done", style: TextStyle(color: Colors.white)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the ClientIssueDetails screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClientIssueDetails(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF001E62)),
                                child: Text("Locate Client", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildServiceHistoryList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Company')
            .doc("YOUR_COMPANY_ID")
            .collection('service_history')
            .orderBy('completed_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No service history available."));
          }

          var completedRequests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: completedRequests.length,
            itemBuilder: (context, index) {
              var data = completedRequests[index].data() as Map<String, dynamic>;

              var car_no = data['car_no'] ?? 'Unknown';
              var car_color = data['car_color'] ?? 'Unknown';
              var selected_service = data['selected_service'] ?? 'Unknown';
              var selected_vehicle = data['selected_vehicle'] ?? 'Unknown';
              var completedAt = data['completed_at'] as Timestamp?;

              String formattedTime = completedAt != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                          completedAt.millisecondsSinceEpoch)
                      .toLocal()
                      .toString()
                  : 'Not available';

              return Card(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Completed Service", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        "$selected_vehicle |  $selected_service | $car_no | $car_color",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 6),
                      Text("Completed at: $formattedTime", style: TextStyle(color: Color(0xFF001E62), fontSize: 13)),
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
