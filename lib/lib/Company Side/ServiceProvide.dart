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
  List<Map<String, dynamic>> availableServices = [];

  void saveToFirestore() {
    if (selectedServiceType != null && selectedService != null) {
      FirebaseFirestore.instance.collection('selectedServices').add({
        'serviceType': selectedServiceType,
        'service': selectedService,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Saved: $selectedServiceType - $selectedService")),
      );
    }
  }

  void updateAvailableServices(String type) {
    setState(() {
      selectedServiceType = type;
      availableServices = serviceOptions[type] ?? [];
      selectedService = null;
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
          const Text(
            "Service Provide For",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
          const Text(
            "Your Service",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: availableServices
                  .map((service) =>
                      _serviceCard(service["name"], service["icon"]))
                  .toList(),
            ),
          ),
          if (selectedServiceType != null && selectedService != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: saveToFirestore,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF001E62)),
                child: Text("Done", style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
      drawer: CompanyDrawer(),
    );
  }

  Widget _serviceType(String title, String imagePath) {
    bool isSelected = selectedServiceType == title;
    return GestureDetector(
      onTap: () => updateAvailableServices(title),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isSelected ? Color(0xFF001E62) : Colors.grey,
                  width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                if (isSelected)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Icon(Icons.check_circle,
                        color: Color(0xFF001E62), size: 22),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Color(0xFF001E62) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(String title, IconData icon) {
    bool isSelected = selectedService == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService = title;
        });
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
            ],
          ),
        ),
      ),
    );
  }
}
