import 'package:firebase_app/lib/User%20Side/home_screen.dart';
import 'package:firebase_app/lib/User%20Side/service_card.dart';
import 'package:firebase_app/lib/User%20Side/service_card2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetServices extends StatefulWidget {
  const GetServices({super.key});

  @override
  _GetServicesState createState() => _GetServicesState();
}

class _GetServicesState extends State<GetServices> {
  String? selectedService;

  @override
  void initState() {
    super.initState();
    fetchSelectedService();
  }

  void fetchSelectedService() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('userSelectedService')
        .doc('currentService')
        .get();

    if (doc.exists) {
      setState(() {
        selectedService = doc['service'];
      });
    }
  }

  void sendRequest(String requestId) async {
    DocumentSnapshot requestDoc = await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .get();

    if (requestDoc.exists) {
      Map<String, dynamic> requestData =
          requestDoc.data() as Map<String, dynamic>;

      // Add the request to the pending_requests collection
      await FirebaseFirestore.instance.collection('pending_requests').add({
        'userId': 'user123', // Replace with actual user ID
        'service': requestData['service'],
        'location': requestData['location'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Navigate to Home Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF001E62), Colors.white],
                ),
              ),
              child: Center(
                child: Text(
                  "Get Services",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Selected Service Card (if exists)
            if (selectedService != null)
              Center(
                child: ServiceCard(
                  icon: Icons.car_repair,
                  title: selectedService!,
                ),
              ),
            SizedBox(height: 10),

            // "Services provided nearby you" section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Services provided nearby you',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Firestore Data: Fetching Service Requests
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No service requests available."));
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildServiceCard(
                              title: "Service Request",
                              address: doc['location'],
                              rating: 4.5, // Placeholder rating
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: ElevatedButton(
                                  onPressed: () => sendRequest(doc.id),
                                  child: Text(
                                    "Send Request",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF001E62),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 20),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
