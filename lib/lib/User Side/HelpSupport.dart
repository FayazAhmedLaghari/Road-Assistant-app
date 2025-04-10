import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  final String phoneNumber = "+92 3443680807"; // Replace with actual number
  final String whatsappMessage = "Hello! I’d like to ask about your services.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Color(0xFF001E62), Colors.white],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                 
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Help & Support',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/HelpSupport.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Need some helps?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Get lost? Don’t know how to use?\nFeel free to get in touch with us",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Contact Us -> CALL
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () => _handleButtonPress("Call"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001E62),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Contact Us',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // FAQ -> WhatsApp Message
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: OutlinedButton(
                        onPressed: () => _handleButtonPress("Message"),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF001E62)),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFF001E62)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonPress(String type) async {
    if (type == "Message") {
      final whatsappUrl = Uri.parse(
          "https://wa.me/${phoneNumber.replaceAll('+', '')}?text=${Uri.encodeComponent(whatsappMessage)}");
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch WhatsApp");
      }
    } else if (type == "Call") {
      final callUrl = Uri.parse("tel:$phoneNumber");
      if (await canLaunchUrl(callUrl)) {
        await launchUrl(callUrl);
      } else {
        debugPrint("Could not open dialer");
      }
    }
  }
}
