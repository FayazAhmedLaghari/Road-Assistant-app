import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Company Side/Location_Picker.dart';
import 'GetService.dart';

class RequestConfirmation extends StatefulWidget {
  const RequestConfirmation({super.key});

  @override
  State<RequestConfirmation> createState() => _RequestConfirmationState();
}

class _RequestConfirmationState extends State<RequestConfirmation> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  final TextEditingController carNoController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();

  bool isFormValid = false;

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
    if (!_formKey.currentState!.validate()) return;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('requests').add({
        'car_no': carNoController.text,
        'car_color': carColorController.text,
        'location': locationController.text,
        'details': detailsController.text,
        'contact_no': contactNoController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request Submitted Successfully")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GetServices()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  LatLng? selectedLocation;
  Future<void> _pickLocation() async {
    LatLng? location = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );
    if (location != null) {
      setState(() {
        selectedLocation = location;
      });

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        if (placemarks.isNotEmpty) {
          setState(() {
            locationController.text =
                "${placemarks.first.street}, ${placemarks.first.locality}";
          });
        }
      } catch (e) {
        print("Error fetching address: $e");
      }
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
              const Text(
                "Flat tire",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              buildSection("Vehicle Details", Icons.directions_car, [
                buildInputField("Car No", carNoController),
                buildInputField("Car Color", carColorController),
              ]),
              const SizedBox(height: 15),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Enter your address",
                  prefixIcon: Icon(Icons.home),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_on, color: Color(0xFF001E62)),
                    onPressed: _pickLocation,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
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
                      backgroundColor: const Color(0xFF001E62),
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

  Widget buildAddressField(
      TextEditingController controller, VoidCallback onLocationPick) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Enter your address",
        prefixIcon: const Icon(Icons.home),
        suffixIcon: IconButton(
          icon: const Icon(Icons.location_on, color: Color(0xFF001E62)),
          onPressed: onLocationPick,
        ),
        border: const OutlineInputBorder(),
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
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(width: 1, color: Color(0xFF001E62)),
          ),
          suffixIcon: icon != null ? Icon(icon, color: Colors.grey[600]) : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }
          return null;
        },
        onChanged: (value) {
          checkFormValid();
        },
      ),
    );
  }
}
