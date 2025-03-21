import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home_screen.dart';
import 'RequestConfirmation.dart';

class RequestServiceScreen extends StatefulWidget {
  @override
  _RequestServiceScreenState createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  List<Map<String, dynamic>> services = [];
  String? selectedService;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void fetchServices() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('selectedServices').get();
    List<Map<String, dynamic>> fetchedServices = querySnapshot.docs
        .map((doc) => {
              "name": doc["service"],
              "icon": Icons.miscellaneous_services,
            })
        .toList();
    setState(() {
      services = fetchedServices;
    });
  }

  void saveSelectedService() async {
    if (selectedService != null) {
      await FirebaseFirestore.instance
          .collection('userSelectedService')
          .doc('currentService')
          .set({'service': selectedService});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          Container(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Request a Service',
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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                              color:
                                  isSelected ? Colors.blue[100] : Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: isSelected
                                    ? Color(0xFF001E62)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? Colors.blue
                                            : Color(0xFF001E62),
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(
                                        service['icon'],
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      service['name'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Icon(Icons.check_circle,
                                        color: Color(0xFF001E62), size: 24),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedService != null
                            ? const Color(0xFF001E62)
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: selectedService != null
                          ? () {
                              saveSelectedService(); // Save selected service
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RequestConfirmation(),
                                ),
                              );
                            }
                          : null,
                      child: const Text(
                        'Confirm Issue',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
