import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'GetService.dart';

class RequestConfirmation extends StatefulWidget {
  const RequestConfirmation({super.key});

  @override
  State<RequestConfirmation> createState() => _RequestConfirmationState();
}

class _RequestConfirmationState extends State<RequestConfirmation> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController carNoController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();

  bool isFormValid = false;
  String selectedService = "Loading...";
  String selectedVehicle = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchSelectedData();
  }

  Future<void> fetchSelectedData() async {
    try {
      DocumentSnapshot serviceDoc = await FirebaseFirestore.instance
          .collection('userSelectedService')
          .doc('currentService')
          .get();

      if (serviceDoc.exists) {
        setState(() {
          selectedService = serviceDoc['service'] ?? "Unknown Service";
          selectedVehicle = serviceDoc['vehicle'] ?? "Unknown Vehicle";
        });
      }
    } catch (e) {
      print("Error fetching service: $e");
    }
  }

  void checkFormValid() {
    setState(() {
      isFormValid = carNoController.text.isNotEmpty &&
          carColorController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          detailsController.text.isNotEmpty &&
          contactNoController.text.isNotEmpty;
    });
  }

  Future<void> saveRequestToFirestore() async {
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      return;
    }

    print("Saving request to Firestore...");

    try {
      await FirebaseFirestore.instance.collection('requests').add({
        'car_no': carNoController.text,
        'car_color': carColorController.text,
        'location': locationController.text,
        'details': detailsController.text,
        'contact_no': contactNoController.text,
        'selected_service': selectedService,
        'selected_vehicle': selectedVehicle,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Request submitted successfully");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request Submitted Successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetServices()),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
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
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Positioned(
                      top: 80,
                      child: Text(
                        "Request Confirmation",
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
              const SizedBox(height: 20),
              Text(
                selectedService,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                "Vehicle: $selectedVehicle",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              buildSection("Vehicle Details", Icons.directions_car, [
                buildInputField("Car No", carNoController),
                buildInputField("Car Color", carColorController),
              ]),
              buildSection("Location", Icons.location_on, [
                buildInputField("Enter Location", locationController,
                    icon: Icons.location_on),
              ]),
              buildSection("Details", Icons.list, [
                buildInputField("Describe the issue", detailsController,
                    maxLines: 5),
              ]),
              buildSection("Contact No", Icons.phone, [
                buildInputField("Enter Contact No", contactNoController),
              ]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isFormValid ? saveRequestToFirestore : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFormValid ? const Color(0xFF001E62) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "Confirm and Request",
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
        ),
      ),
    );
  }

  Widget buildSection(String title, IconData icon, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[700]),
              const SizedBox(width: 10),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ...children
        ],
      ),
    );
  }

  Widget buildInputField(String hint, TextEditingController controller,
      {IconData? icon, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (value) =>
            checkFormValid(), // Update form validation dynamically
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          suffixIcon: icon != null ? Icon(icon, color: Colors.grey[600]) : null,
        ),
      ),
    );
  }
}
