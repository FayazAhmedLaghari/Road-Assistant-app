import 'package:firebase_app/lib/User%20Side/service_card.dart';
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
            if (selectedService != null)
              Center(
                child: ServiceCard(
                  icon: Icons.car_repair,
                  title: selectedService!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
