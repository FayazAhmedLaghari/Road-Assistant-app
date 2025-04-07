import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import '../home_screen.dart';
import 'RequestConfirmation.dart';

class RequestServiceScreen extends StatefulWidget {
  @override
  _RequestServiceScreenState createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  List<Map<String, dynamic>> services = [];
  String? selectedService;
  String? selectedVehicle;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showVehicleSelectionDialog();
    });
  }

  // Show vehicle selection dialog
  void _showVehicleSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text('Select Your Vehicle',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildVehicleOption('Car', 'assets/car.png'),
              _buildVehicleOption('Motorcycle', 'assets/motorcycle.png'),
              _buildVehicleOption('Rickshaw', 'assets/rickshaw.png'),
            ],
          ),
        );
      },
    );
  }

  // Vehicle selection option
  Widget _buildVehicleOption(String vehicle, String imagePath) {
    return ListTile(
      leading:
          Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.contain),
      title: Text(vehicle, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        setState(() {
          selectedVehicle = vehicle;
        });
        Navigator.pop(context);
        fetchServices(vehicle);
      },
    );
  }

  // Local hardcoded services based on vehicle type
  void fetchServices(String vehicleType) {
    setState(() => isLoading = true);

    List<Map<String, dynamic>> fetchedServices = [];

    if (vehicleType == 'Car') {
      fetchedServices = [
             {"name": "Flat Tire", "icon": Icons.tire_repair},
      {"name": "Battery Jump Start", "icon": Icons.battery_charging_full},
      {"name": "Towing Service", "icon": Icons.local_shipping},
      {"name": "Engine Overheating", "icon": Icons.warning},
      {"name": "Brake Issue", "icon": Icons.car_repair},
      {"name": "Oil Change", "icon": Icons.oil_barrel},
      {"name": "AC Repair", "icon": Icons.ac_unit},
      ];
    } else if (vehicleType == 'Motorcycle') {
      fetchedServices = [
        {"name": "Flat Tire", "icon": Icons.tire_repair},
      {"name": "Chain Adjustment", "icon": Icons.build},
      {"name": "Battery Issue", "icon": Icons.battery_alert},
      {"name": "Engine Tune-Up", "icon": Icons.engineering},
      {"name": "Brake Pad Change", "icon": Icons.settings},
      {"name": "Clutch Repair", "icon": Icons.precision_manufacturing},
      {"name": "Light Issue", "icon": Icons.lightbulb},
      ];
    } else if (vehicleType == 'Rickshaw') {
      fetchedServices = [
        {"name": "Battery Problem", "icon": Icons.battery_alert},
      {"name": "Flat Tire", "icon": Icons.tire_repair},
      {"name": "Towing Service", "icon": Icons.local_shipping},
      {"name": "Engine Repair", "icon": Icons.miscellaneous_services},
      {"name": "Meter Issue", "icon": Icons.speed},
      {"name": "Brake Problem", "icon": Icons.car_repair},
      {"name": "Seat Repair", "icon": Icons.event_seat},
      ];
    }

    setState(() {
      services = fetchedServices;
      isLoading = false;
    });
  }

  // Save selected service to Firestore
  void saveSelectedService() async {
    if (selectedService != null) {
      await FirebaseFirestore.instance
          .collection('userSelectedService')
          .doc('currentService')
          .set({
        'service': selectedService,
        'vehicle': selectedVehicle,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How can we assist you?',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                      child: isLoading
                          ? _buildShimmerEffect()
                          : _buildServiceGrid()),
                  const SizedBox(height: 16.0),
                  _buildConfirmButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header UI
  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF001E62), Colors.white],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Request a Service',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Service selection grid
  Widget _buildServiceGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        bool isSelected = selectedService == service['name'];

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedService = service['name'];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[100] : Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color:
                    isSelected ? const Color(0xFF001E62) : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(service['icon'], color: Color(0xFF001E62), size: 40.0),
                const SizedBox(height: 8.0),
                Text(service['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }

  // Confirmation button
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedService != null ? const Color(0xFF001E62) : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onPressed: selectedService != null
            ? () {
                saveSelectedService();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestConfirmation()));
              }
            : null,
        child: const Text('Confirm Issue',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
      ),
    );
  }

  // Loading shimmer effect
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
          );
        },
      ),
    );
  }
}
