import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CompanyNotification.dart';
import 'Drawer.dart';

class ServiceProvide extends StatefulWidget {
  @override
  _ServiceProvideState createState() => _ServiceProvideState();
}

class _ServiceProvideState extends State<ServiceProvide> {
  String? selectedServiceType;
  String? selectedService;
  List<String> activeServices = [];

  Map<String, List<Map<String, dynamic>>> serviceOptions = {
    "Car": [
      {"name": "Flat tire", "icon": Icons.tire_repair},
      {"name": "Towing Service", "icon": Icons.local_shipping},
      {"name": "Engine Heat", "icon": Icons.warning},
      {"name": "Battery Jump Start", "icon": Icons.battery_charging_full},
    ],
    "MotorCycle": [
      {"name": "Flat tire", "icon": Icons.tire_repair},
      {"name": "Engine Check", "icon": Icons.settings},
      {"name": "Key Lock", "icon": Icons.vpn_key},
    ],
    "Rickshaw": [
      {"name": "Engine Check", "icon": Icons.settings},
      {"name": "Towing Service", "icon": Icons.local_shipping},
      {"name": "Battery Jump Start", "icon": Icons.battery_charging_full},
    ],
  };

  void _fetchSelectedServices() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('selectedServices').get();
    setState(() {
      activeServices =
          snapshot.docs.map((doc) => doc['service'] as String).toList();
    });
  }

  void saveToFirestore() {
    if (selectedServiceType != null &&
        selectedService != null &&
        !activeServices.contains(selectedService)) {
      FirebaseFirestore.instance.collection('selectedServices').add({
        'serviceType': selectedServiceType,
        'service': selectedService,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        activeServices.add(selectedService!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Saved: $selectedServiceType - $selectedService")),
      );
    } else if (activeServices.contains(selectedService)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$selectedService is already added.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSelectedServices();
  }

  void updateAvailableServices(String type) {
    setState(() {
      selectedServiceType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF001E62), Colors.white],
              ),
            ),
            padding: const EdgeInsets.all(16.0),
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
                  icon: Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CompanyNotificationsScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Service Provide For",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _serviceType("Car", "assets/car.png"),
              _serviceType("MotorCycle", "assets/motorcycle.png"),
              _serviceType("Rickshaw", "assets/rickshaw.png"),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Your Service",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: (serviceOptions[selectedServiceType] ?? [])
                  .map((service) =>
                      _serviceCard(service["name"], service["icon"]))
                  .toList(),
            ),
          ),
        ],
      ),
      drawer: CompanyDrawer(),
    );
  }

  Widget _serviceType(String title, String imagePath) {
    return GestureDetector(
      onTap: () => updateAvailableServices(title),
      child: Column(
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          SizedBox(height: 5),
          Text(title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _serviceCard(String title, IconData icon) {
    bool isSelected = activeServices.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService = title;
        });
        saveToFirestore();
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Color(0xFF001E62)),
              SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Icon(isSelected ? Icons.check_circle : Icons.cancel,
                  color: isSelected ? Colors.green : Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
