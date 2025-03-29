import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../home_screen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No service history available"),
            );
          }

          var serviceData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;

          String selectedService =
              serviceData['selected_service'] ?? "Unknown Service";
          String selectedVehicle =
              serviceData['selected_vehicle'] ?? "Unknown Vehicle";
          String location = serviceData['location'] ?? "Unknown Location";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        child: Text(
                          "Feedback",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                CircleAvatar(
                  backgroundColor: Color(0xFF001E62),
                  radius: 40,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.business, color: Colors.black, size: 25),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  selectedService, // Show selected service
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  selectedVehicle, // Show selected vehicle
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  location, // Show location
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 70),
                Text(
                  "How is your experience?",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Your feedback will help improve \nservice experience",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 40),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Color(0xFF001E62),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 180,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Additional Comments",
                        hintStyle: TextStyle(fontSize: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add submit functionality here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF001E62),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Submit Review",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
