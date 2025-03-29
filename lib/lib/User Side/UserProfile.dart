import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/lib/User%20Side/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../LoginOnly.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _image;
  String? _uploadedImageUrl;
  String? _selectedGender;
  bool _isUploadingImage = false;
  bool _isSavingData = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  // 📷 Pick Image from Gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ☁ Upload Image to Cloudinary
  Future<void> _uploadImageToCloudinary() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first.")),
      );
      return;
    }

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final String cloudName =
          "dgbjqewiy"; // Replace with Cloudinary cloud name
      final String uploadPreset = "imageuplaod"; // Replace with upload preset

      final Uri uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      var request = http.MultipartRequest("POST", uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        setState(() {
          _uploadedImageUrl = jsonResponse["secure_url"];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image uploaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload failed. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  // 📝 Store User Data in Firestore
  Future<void> _storeUserData() async {
    if (_ageController.text.isEmpty ||
        int.tryParse(_ageController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid age")),
      );
      return;
    }
    if (_contactController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact number must be 11 digits")),
      );
      return;
    }
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _selectedGender == null ||
        _contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      _isSavingData = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not authenticated!");
      }

      // Fetch userType from SharedPreferences (if previously stored)
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userType = prefs.getString("userType") ??
          "User"; // Default to "User" if not found

      // Fetch existing user data to retain current image if no new upload
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String? existingImageUrl = userDoc.exists ? userDoc['imageUrl'] : null;
      String imageUrlToSave = _uploadedImageUrl ?? existingImageUrl ?? "";

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'age': _ageController.text.trim(),
        'gender': _selectedGender,
        'contact': _contactController.text.trim(),
        'imageUrl': imageUrlToSave, // Store Cloudinary image URL
        'userType': userType, // 🔥 Store userType in Firestore
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Created Successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isSavingData = false;
      });
    }
  }

  InputDecoration customInputDecoration(String hintText, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: hintText,
      prefixIcon: Icon(icon, color: Color(0xFF001E62)),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF001E62)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF001E62), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
            child: const Center(
              child: Text(
                "Create Profile",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(Icons.camera_alt,
                                size: 40, color: Colors.black54)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          _isUploadingImage ? null : _uploadImageToCloudinary,
                      child: _isUploadingImage
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Upload Image",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001E62),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(08)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration:
                        customInputDecoration("Enter your name", Icons.person),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _addressController,
                    decoration: customInputDecoration(
                      "Enter your address",
                      Icons.home,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_on, color: Color(0xFF001E62)),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _ageController,
                    decoration: customInputDecoration(
                        "Enter your age", Icons.calendar_today),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    decoration:
                        customInputDecoration("Select your gender", Icons.wc),
                    value: _selectedGender,
                    items: ["Male", "Female"].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _contactController,
                    decoration: customInputDecoration(
                        "Enter your contact number", Icons.phone),
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSavingData ? null : _storeUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001E62),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isSavingData
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Create Profile",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
