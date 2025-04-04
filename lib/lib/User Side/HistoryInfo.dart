import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Request/Feedback.dart';

class HistoryInformation extends StatefulWidget {
  final Map<String, dynamic> requestData;

  const HistoryInformation({Key? key, required this.requestData})
      : super(key: key);

  @override
  _HistoryInformationState createState() => _HistoryInformationState();
}

class _HistoryInformationState extends State<HistoryInformation> {
  String _userName = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      if (widget.requestData['user_id'] != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.requestData['user_id'])
            .get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['name'] ?? "No Name";
          });
        } else {
          setState(() {
            _userName = "Unknown User";
          });
        }
      }
    } catch (e) {
      print("Error fetching user name: $e");
      setState(() {
        _userName = "Error";
      });
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
            // 🔹 Gradient Header
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
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
                      widget.requestData['selected_vehicle'] ?? "N/A"),
                  buildInfo("Service",
                      widget.requestData['selected_service'] ?? "N/A"),
                  buildInfo(
                      "Vehicle No", widget.requestData['car_no'] ?? "N/A"),
                  buildInfo("Vehicle Color",
                      widget.requestData['car_color'] ?? "N/A"),
                  buildInfo(
                      "Location", widget.requestData['location'] ?? "N/A"),
                  buildInfo(
                      "Issue Details", widget.requestData['details'] ?? "N/A"),
                  const SizedBox(height: 10),
                  const Text('Other Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 10),
                  buildInfo("Name", _userName),
                  buildInfo(
                      "Date",
                      widget.requestData['timestamp'] != null
                          ? widget.requestData['timestamp'].toDate().toString()
                          : "N/A"),
                  buildInfo(
                      "Contact No", widget.requestData['contact_no'] ?? "N/A"),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            "Give Feedback",
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
                text: "$title: ",
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
