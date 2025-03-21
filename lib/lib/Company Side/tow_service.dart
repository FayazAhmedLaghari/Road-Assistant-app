import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BuildServiceCard.dart';
import 'CompanyNotification.dart';
import 'Drawer.dart';

class TowServiceScreen extends StatefulWidget {
  const TowServiceScreen({super.key});

  @override
  _TowServiceScreenState createState() => _TowServiceScreenState();
}

class _TowServiceScreenState extends State<TowServiceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String companyId = "2PEn04QtiMXkNk1h6Qe3Vk4fE2"; // 🔹 Replace if needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBar(context),
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
                    _buildDoneServiceList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blue,
      //   onPressed: () {
      //     _showAddServiceDialog(context);
      //   },
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
      drawer: CompanyDrawer(),
    );
  }

  Widget _buildHeaderBar(BuildContext context) {
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
                      builder: (context) => const CompanyNotificationsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF001E62),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("EeZee Tow",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildDoneServiceList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Company')
          .doc(companyId)
          .collection('done_services')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No services available."));
        }

        var services = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, index) {
            var service = services[index];
            var serviceId = service.id;

            var data = service.data() as Map<String, dynamic>;
            var customerName = data['customer_name'] ?? 'Unknown';
            var vehicleType = data['vehicle_type'] ?? 'Unknown';
            var vehicleBrand = data['vehicle_brand'] ?? 'Unknown';
            var vehicleModel = data['vehicle_model'] ?? 'Unknown';
            var fuelType = data['fuel_type'] ?? 'Unknown';
            var plateNumber = data['plate_number'] ?? 'Unknown';

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 6,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customerName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      "$vehicleType | $vehicleBrand | $vehicleModel | $fuelType | $plateNumber",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF001E62)),
                          onPressed: () => _acceptService(serviceId, data),
                          child: Text("Accept",
                              style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF001E62)),
                          onPressed: () => _declineService(serviceId, data),
                          child: Text("Decline",
                              style: TextStyle(color: Colors.white)),
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
  }

  void _acceptService(String serviceId, Map<String, dynamic> data) async {
    await _firestore
        .collection('Company')
        .doc(companyId)
        .collection('accepted_services')
        .doc(serviceId)
        .set(data);
    await _firestore
        .collection('Company')
        .doc(companyId)
        .collection('done_services')
        .doc(serviceId)
        .delete();
  }

  void _declineService(String serviceId, Map<String, dynamic> data) async {
    await _firestore
        .collection('Company')
        .doc(companyId)
        .collection('declined_services')
        .doc(serviceId)
        .set(data);
    await _firestore
        .collection('Company')
        .doc(companyId)
        .collection('done_services')
        .doc(serviceId)
        .delete();
  }
}
