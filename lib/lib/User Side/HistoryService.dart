import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'HistoryInfo.dart';

class ServiceHistory extends StatelessWidget {
  final List<Service> services = [
    Service(
      "Flat tire",
      "Gotham Car Reparation",
      "Yesterday",
    ),
    Service(
      "Towing Service",
      "Gotham Car Reparation",
      "Tue Feb 3, 2025",
    ),
    Service("Key lock assistance", "Gotham Car Reparation", "Tue Feb 3, 2025"),
    Service("Towing Service", "Gotham Car Reparation", "Tue Feb 3, 2025"),
  ];

  ServiceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
            child: Stack(alignment: AlignmentDirectional.center, children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 80,
                child: Text(
                  "History of Services",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Text(
              "Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('selectedServices') // Fetching from Firestore
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
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: serviceRequests.length,
                  itemBuilder: (context, index) {
                    var serviceData =
                        serviceRequests[index].data() as Map<String, dynamic>;
                    var serviceType = serviceData['serviceType'] ?? 'Unknown';
                    var serviceName = serviceData['service'] ?? 'Unknown';
                    var timestamp = serviceData['timestamp'] as Timestamp?;

                    String formattedDate = timestamp != null
                        ? "${timestamp.toDate().toLocal()}"
                        : "Unknown time";

                    return Card(
                      shadowColor: Color.fromARGB(255, 32, 121, 194),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceType,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(serviceName),
                            SizedBox(height: 10),
                            Text(
                              formattedDate,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // Center(
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       // Handle completion action here
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //         backgroundColor: Color(0xFF001E62)),
                            //     child: Text("Done", style: TextStyle(color: Colors.white)),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryInformation(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001E62),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
              child: const Text(
                " Details ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildServiceCard(BuildContext context, Service service) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                child: const Icon(Icons.directions_car,
                    size: 40, color: Color(0xFF001E62)),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled,
                          size: 16, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        service.time,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        service.address,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryInformation(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001E62),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                        ),
                        child: const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "House 19, Road 6 Block D, Islamabad",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            service.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

class Service {
  final String title;
  final String address;
  final String time;
  Service(this.title, this.address, this.time);
}
