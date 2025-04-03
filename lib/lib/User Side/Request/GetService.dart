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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSelectedService();
  }

  void fetchSelectedService() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('userSelectedService')
          .doc('currentService')
          .get();

      if (doc.exists) {
        setState(() {
          selectedService = doc['service'];
        });
      } else {
        print("No service found in Firestore");
      }
    } catch (e) {
      print("Error fetching service: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendRequest(String requestId) async {
    try {
      DocumentSnapshot requestDoc = await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .get();

      if (requestDoc.exists) {
        Map<String, dynamic> requestData =
            requestDoc.data() as Map<String, dynamic>;

        await FirebaseFirestore.instance.collection('pending_requests').add({
          'userId': 'user123', // Replace with actual user ID
          'service': requestData['service'],
          'location': requestData['location'],
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Navigate to Home Screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        print("Request document not found!");
      }
    } catch (e) {
      print("Error sending request: $e");
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF001E62), Colors.white],
                ),
              ),
              child: const Center(
                child: Text(
                  "Get Services",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Loading Indicator
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (selectedService != null)
              Center(
                child: ServiceCard(
                  icon: Icons.car_repair,
                  title: selectedService!,
                ),
              )
            else
              const Center(child: Text("No selected service found")),
            const SizedBox(height: 10),

            // Services Provided Nearby
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Services provided nearby you',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Fetching Company Data from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Company') // Use your correct collection
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No companies found nearby."));
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildServiceCard(
                              title: doc['name'] ?? 'Unknown Company',
                              address: doc['address'] ?? 'No address provided',
                              rating:
                                  4.5, // Placeholder rating or dynamic if available
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: ElevatedButton(
                                onPressed: () => sendRequest(doc.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF001E62),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 20),
                                ),
                                child: const Text("Send Request",
                                    style: TextStyle(color: Colors.white)),
                              ),
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
