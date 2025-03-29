import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Request/Feedback.dart';

class HistoryInformation extends StatefulWidget {
  @override
  _HistoryInformationState createState() => _HistoryInformationState();
}

class _HistoryInformationState extends State<HistoryInformation> {
  Map<String, dynamic>? requestData;
  String _userName = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchLatestRequest();
    fetchUserName();
  }

  Future<void> fetchLatestRequest() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          requestData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print("Error fetching history: $e");
    }
  }

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? "No Name";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: requestData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 SAME Gradient Header
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Color(0xFF001E62), Colors.white],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.black),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                        const Center(
                          child: Text(
                            "History Information",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfo("Vehicle",
                            requestData!['selected_vehicle'] ?? "N/A"),
                        buildInfo("Service",
                            requestData!['selected_service'] ?? "N/A"),
                        buildInfo("Car No", requestData!['car_no'] ?? "N/A"),
                        buildInfo(
                            "Car Color", requestData!['car_color'] ?? "N/A"),
                        buildInfo(
                            "Location", requestData!['location'] ?? "N/A"),
                        buildInfo(
                            "Issue Details", requestData!['details'] ?? "N/A"),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Other Details',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        buildInfo("Name", _userName),
                        buildInfo(
                            "Date",
                            requestData?['timestamp'] != null
                                ? DateTime.fromMillisecondsSinceEpoch(
                                        requestData!['timestamp']
                                            .millisecondsSinceEpoch)
                                    .toString()
                                : "N/A"),
                        buildInfo(
                            "Contact No", requestData!['contact_no'] ?? "N/A"),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FeedbackScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF001E62),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: const Text(
                                  "Give Feedback",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(
                text: "$title : ",
                style: const TextStyle(fontWeight: FontWeight.normal)),
            TextSpan(
                text: value,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
