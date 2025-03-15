import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'Company Side/CompanyProfile.dart';
class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  EmailOTP myAuth = EmailOTP();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOTPSent = false; // Track if OTP is sent
  /// **Send OTP to Email**
  Future<void> sendOTP() async {
    // myAuth.setConfig(
    //   appEmail: "your-email@gmail.com", // 🔹 Replace with your email
    //   appName: "MyApp",
    //   userEmail: _emailController.text.trim(),
    //   otpLength: 6,
    //   otpType: OTPType.numeric,
    // );
    bool result =
        await EmailOTP.sendOTP(email: _emailController.text.toString());
    if (result) {
      setState(() {
        _isOTPSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ OTP Sent Successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to Send OTP. Try Again!")),
      );
    }
  }

  /// **Verify OTP**
  Future<void> verifyOTP() async {
    bool verified = await EmailOTP.verifyOTP(otp: _otpController.text.trim());
    if (verified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ OTP Verified Successfully!")),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CompanyProfile()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Invalid OTP! Try Again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Email OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration:
                  const InputDecoration(labelText: "📧 Enter your Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: sendOTP,
              child: const Text("📨 Send OTP"),
            ),
            const SizedBox(height: 20),
            if (_isOTPSent) ...[
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: "🔢 Enter OTP"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: verifyOTP,
                child: const Text("✅ Verify OTP"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
