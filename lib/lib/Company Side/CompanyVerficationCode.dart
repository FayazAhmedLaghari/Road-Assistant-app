import 'dart:async';
import 'package:flutter/material.dart';
import 'CompanyProfile.dart';

class Companyverficationcode extends StatefulWidget {
  final String correctOTP;
  Companyverficationcode({super.key, required this.correctOTP});
  @override
  State<Companyverficationcode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<Companyverficationcode> {
  late Timer _timer;
  int _secondsRemaining = 300;
  final TextEditingController _otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOTP() async {
    String enteredOTP = _otpController.text.trim();
    print("Entered OTP: $enteredOTP");
    print("Correct OTP: ${widget.correctOTP}");

    if (enteredOTP == widget.correctOTP) {
      // Show success message before navigating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP verified successfully! Redirecting..."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), // Show for 2 seconds
        ),
      );
      // Wait for the snackbar to show before navigating
      await Future.delayed(Duration(seconds: 2));
      // Navigate to the profile screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CompanyProfile()),
      );
    } else {
      // Show error message for incorrect OTP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Incorrect OTP. Please try again."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
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
                end: Alignment.center,
                colors: [Color(0xFF001E62), Colors.white],
              ),
            ),
            child: const Center(
              child: Text(
                'Verification',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  TextField(
                    controller: _otpController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Enter OTP',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Time Remaining: ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF001E62),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _verifyOTP,
                      child: const Text(
                        'Verify',
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
