import 'package:flutter/material.dart';
import 'CompanyNotification.dart';
import 'Drawer.dart';

class ServiceProvide extends StatefulWidget {
  @override
  _ServiceProvideState createState() => _ServiceProvideState();
}

class _ServiceProvideState extends State<ServiceProvide> {
  String? selectedServiceType;
  String? selectedService;

  // ✅ Local services (no Firebase)
  Map<String, List<Map<String, dynamic>>> serviceOptions = {
    "Car": [
      {"name": "Flat Tire", "icon": Icons.tire_repair},
      {"name": "Battery Jump Start", "icon": Icons.battery_charging_full},
      {"name": "Towing Service", "icon": Icons.local_shipping},
      {"name": "Engine Overheating", "icon": Icons.warning},
      {"name": "Brake Issue", "icon": Icons.car_repair},
      {"name": "Oil Change", "icon": Icons.oil_barrel},
      {"name": "AC Repair", "icon": Icons.ac_unit},
    ],
    "MotorCycle": [
      {"name": "Flat Tire", "icon": Icons.tire_repair},
      {"name": "Chain Adjustment", "icon": Icons.build},
      {"name": "Battery Issue", "icon": Icons.battery_alert},
      {"name": "Engine Tune-Up", "icon": Icons.engineering},
      {"name": "Brake Pad Change", "icon": Icons.settings},
      {"name": "Clutch Repair", "icon": Icons.precision_manufacturing},
      {"name": "Light Issue", "icon": Icons.lightbulb},
    ],
    "Rickshaw": [{"name": "Battery Problem", "icon": Icons.battery_alert},
      {"name": "Flat Tire", "icon": Icons.tire_repair},
      {"name": "Towing Service", "icon": Icons.local_shipping},
      {"name": "Engine Repair", "icon": Icons.miscellaneous_services},
      {"name": "Meter Issue", "icon": Icons.speed},
      {"name": "Brake Problem", "icon": Icons.car_repair},
      {"name": "Seat Repair", "icon": Icons.event_seat},
      
    ],
  };

  void updateAvailableServices(String type) {
    setState(() {
      selectedServiceType = type;
      selectedService = null; // Reset selected service
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
    bool isSelected = selectedServiceType == title;
    return GestureDetector(
      onTap: () => updateAvailableServices(title),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.asset(imagePath, width: 50, height: 50),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected: $title")),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Color(0xFF001E62)),
              const SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Colors.green : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
