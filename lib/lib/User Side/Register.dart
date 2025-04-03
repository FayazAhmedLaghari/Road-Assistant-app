import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Company Side/CompanyVerficationCode.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../LoginOnly.dart';
import 'VerificationCode.dart';
import 'email_otp.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String userType = "User";
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}$');
    return regex.hasMatch(password);
  }

  void _register() async {
    String recipientEmail = _emailController.text.trim();

    // Check for network connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No internet connection. Please check and try again."),
        backgroundColor: Colors.red,
      ));
      return; // Ensure the function stops execution here
    }

    if (recipientEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter Email"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter your password"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter your Confirm password"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match!"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!_isValidPassword(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Password must have at least 8 characters, one uppercase, one lowercase, and one special character."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: recipientEmail,
        password: _passwordController.text.trim(),
      );

      String generatedOtp = generateOTP();
      bool otpSent = await sendOTP(recipientEmail, generatedOtp);
      if (otpSent) {
        print("Stored OTP for verification: $generatedOtp");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful! Check your email for OTP."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => userType == "User"
                  ? VerificationCode(
                      correctOTP: generatedOtp,
                      onResendOTP: () => sendOTP(recipientEmail, generatedOtp))
                  : CompanyVerificationCode(
                      correctOTP: generatedOtp,
                      onResendOTP: () => sendOTP(recipientEmail, generatedOtp)),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to send OTP. Try again!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registration failed: ${e.message}"),
        backgroundColor: Colors.red,
      ));
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No internet connection. Please check and try again."),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registration failed: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                end: Alignment.center,
                colors: [Color(0xFF001E62), Colors.white],
              ),
            ),
            child: const Center(
              child: Text(
                "Register",
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
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
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF001E62)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF001E62),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: "Enter your Confirm password",
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF001E62)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF001E62),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 15),
                  const Text("User Type"),
                  Row(
                    children: [
                      Radio(
                        value: "User",
                        groupValue: userType,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  userType = value.toString();
                                });
                              },
                      ),
                      const Text("User"),
                      Radio(
                        value: "Company",
                        groupValue: userType,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  userType = value.toString();
                                });
                              },
                      ),
                      const Text("Company"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001E62),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => loginOnly(),
                                ),
                              );
                            },
                      child: const Text("Already have an account? Sign In"),
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
