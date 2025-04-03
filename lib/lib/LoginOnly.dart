import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/lib/User%20Side/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Company Side/Tabbar.dart';
import 'User Side/home_screen.dart';
import 'VerificationScreen.dart';

class loginOnly extends StatefulWidget {
  const loginOnly({super.key});
  @override
  State<loginOnly> createState() => _LoginOnlyState();
}

class _LoginOnlyState extends State<loginOnly> {
  bool _isObscure = true;
  bool _isLoading = false;
  String userType = "User";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      print("User logged in with UID: $uid");

      // Fetch user details from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      DocumentSnapshot companyDoc =
          await FirebaseFirestore.instance.collection('Company').doc(uid).get();

      DocumentSnapshot? foundDoc;
      if (userDoc.exists) {
        foundDoc = userDoc;
      } else if (companyDoc.exists) {
        foundDoc = companyDoc;
      }

      if (foundDoc == null) {
        print("User document does not exist in Firestore");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not found in database"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      var userData = foundDoc.data() as Map<String, dynamic>?; // Safe casting
      if (userData == null || !userData.containsKey('userType')) {
        print("Firestore document found, but 'userType' field is missing!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account error: 'userType' field missing."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      String userType = userData['userType'];
      print("User type retrieved: $userType");

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("User", true);
      await prefs.setString("userType", userType);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful."),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate based on user type
      if (userType == "User") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else if (userType == "Company") {
        _getCompanyLocationAndLogin(userCredential);
      } else {
        print("Invalid 'userType' value in Firestore: $userType");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid 'userType' in database."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCompanyLocationAndLogin(
      UserCredential userCredential) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location services are disabled."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission denied."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permission is permanently denied."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      print("Company Location: ${position.latitude}, ${position.longitude}");
      // Get address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      // Format the addressString companyAddress
      String companyAddress =
          " ${place.name ?? 'Unknown Locality'},  ${place.locality ?? 'Unknown Locality'}, ${place.country ?? 'Unknown Country'}";
      print("Company Address: $companyAddress");
      // Navigate to HomeTab with the address
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Hometab(companyAddress: companyAddress),
        ),
      );
    } catch (e) {
      print("Error fetching location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to retrieve location: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your Email",
                        prefixIcon: Icon(Icons.email, color: Color(0xFF001E62)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF001E62)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color.fromARGB(255, 25, 57, 133),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerificationScreen()),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Color(0xFF001E62),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001E62),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Log In",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()),
                                );
                              },
                        child: const Text.rich(
                          TextSpan(
                            text: "Do not have an account? ",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                    color: Color(0xFF001E62),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
