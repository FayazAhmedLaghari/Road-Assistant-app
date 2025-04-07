import 'package:firebase_app/lib/Company%20Side/client_issue_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Drawer.dart';
import 'CompanyNotification.dart';
import 'issue_details.dart';

class TowServiceScreen extends StatefulWidget {
  const TowServiceScreen({super.key});

  @override
  State<TowServiceScreen> createState() => _TowServiceScreenState();
}

class _TowServiceScreenState extends State<TowServiceScreen> {
  List<String> acceptedRequestIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CompanyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _buildHeader(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequestList(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF001E62), Colors.white],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFF001E62), borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text("EeZee Tow",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    ]);
  }

  Widget _buildRequestList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No any new rides for you"));
        }

        var requests = snapshot.data!.docs.where((doc) => !acceptedRequestIds.contains(doc.id)).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            var request = requests[index];
            var data = request.data() as Map<String, dynamic>;

            return BuildRequestCard(
              requestId: request.id,
              user_name: data['user_id'] ?? 'Unknown', // Assuming 'user_id' is in the request data
              carNo: data['car_no'] ?? 'Unknown',
              selected_vehicle: data['selected_vehicle'] ?? 'No Vehicle',
              car_color: data['car_color'] ?? 'No Color',
              selected_service: data['selected_service'] ?? 'No Service',
              car_no: data['car_no'] ?? 'No Vehicle Number',
              onAccepted: () {
                setState(() {
                  acceptedRequestIds.add(request.id); // Add to the accepted list to hide it
                });
              },
            );
          },
        );
      },
    );
  }
}

class BuildRequestCard extends StatelessWidget {
  final String requestId;
  final String carNo;
  final String selected_vehicle;
  final String car_color;
  final String selected_service;
  final String car_no;
  final String user_name;
  final VoidCallback onAccepted;

  const BuildRequestCard({
    required this.requestId,
    required this.carNo,
    required this.selected_vehicle,
    required this.car_color,
    required this.selected_service,
    required this.car_no,
    required this.onAccepted,
    required this.user_name, // user_name passed in this constructor
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users') // Assuming 'users' collection holds user data
                  .doc(user_name) // This should be the user ID stored in the request
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text("User not found");
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String userFullName = userData['name'] ?? 'Unknown User';

                return Text(
                  userFullName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                );
              },
            ),
            SizedBox(height: 4),
            Text(
                "$selected_vehicle |  $selected_service | $car_no | $car_color ",
                style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _acceptRequest(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 16, 19, 27)),
                  child: Text("Accept", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () => _deleteRequest(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001E62)),
                  child: Text("Decline", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var requestDoc = await FirebaseFirestore.instance
                        .collection('requests')
                        .doc(requestId)
                        .get();
                    if (requestDoc.exists) {
                      var requestData = requestDoc.data() as Map<String, dynamic>;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IssueDetails(requestData: requestData),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Request not found")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001E62)),
                  child: Text("View", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _acceptRequest(BuildContext context) async {
    var requestDoc = await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .get();

    if (requestDoc.exists) {
      var data = requestDoc.data() as Map<String, dynamic>;

      // Add to company's service_requests collection
      await FirebaseFirestore.instance
          .collection('Company')
          .doc("YOUR_COMPANY_ID") // Replace with actual ID
          .collection('service_requests')
          .add({
        'car_no': data['car_no'],
        'selected_vehicle': data['selected_vehicle'],
        'car_color': data['car_color'],
        'selected_service': data['selected_service'],
        'timestamp': Timestamp.now(),
      });

      // Don't delete the request, just mark it as accepted
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({'status': 'Accepted'});

      onAccepted(); // Update UI

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request moved to service requests")),
      );
    }
  }

  void _deleteRequest(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Request removed")),
    );
  }
}
