import 'package:firebase_app/lib/Company%20Side/CompanyNotification.dart';
import 'package:firebase_app/lib/Company%20Side/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TowServiceScreen extends StatelessWidget {
  const TowServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    Text("Done Service", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildDoneServiceList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CompanyDrawer(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFF001E62), Colors.white])));
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
      stream: FirebaseFirestore.instance.collection('requests').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No active service requests"));
        }

        var requests = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            var request = requests[index];
            return BuildRequestCard(
              carNo: request['car_no'],
              carColor: request['car_color'],
              location: request['location'],
              details: request['details'],
              contactNo: request['contact_no'],
            );
          },
        );
      },
    );
  }

  Widget _buildDoneServiceList() {
    return Container(); // Implement logic for completed services if needed
  }
}

class BuildRequestCard extends StatelessWidget {
  final String carNo;
  final String carColor;
  final String location;
  final String details;
  final String contactNo;

  const BuildRequestCard({
    required this.carNo,
    required this.carColor,
    required this.location,
    required this.details,
    required this.contactNo,
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
             Text("$carNo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("$carColor | $location | $details | $contactNo | $carNo",
                style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _showPopup(context, true),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF001E62)),
                    child: Text("Accept", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20,),
                   ElevatedButton(
                onPressed: () => _showPopup(context, false),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF001E62)),
                child: Text("Decline", style: TextStyle(color: Colors.white)),
              ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  void _showPopup(BuildContext context, bool isAccept) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications, size: 50, color: Color(0xFF001E62)),
            SizedBox(height: 10),
            Text("You have 1 request to repair", style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {},
              child: Text("Details", style: TextStyle(color: Color(0xFF001E62), fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),

            Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[400]),
                  child: Text("Decline", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF001E62)),
                  child: Text("Accept", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

