import 'package:flutter/material.dart';

import 'client_issue_details.dart';

class IssueDetails extends StatelessWidget {
  const IssueDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Gradient
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xFF001E62), Colors.white],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context); // Fixed back navigation
                          },
                        ),
                        const Text(
                          "Client Issue Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Vehicle Details Card
            _buildCard(
              title: "Vehicle Details",
              children: [
                _buildDetailRow("Vehicle Owner", "Mr. Weslewski"),
                _buildDetailRow("Vehicle Type", "Car"),
                _buildDetailRow("Vehicle Name", "Toyota"),
                _buildDetailRow(
                    "Vehicle Color", "Blue"), // Fixed incorrect value
              ],
            ),

            const SizedBox(height: 16),

            // Client Service Request Card
            _buildCard(
              title: "Client Service Request",
              children: [
                _buildDetailRow("Client Issue Type", "Flat Tyre"),
                _buildDetailRow("Client Location", "Locate Client",
                    isLink: true),
                _buildDetailRow("Client Contact", "02...."),
              ],
            ),

            const SizedBox(height: 16),

            // Client Added Text Card
            _buildCard(
              title: "Client Added Text",
              children: [
                const Text(
                  "Description :",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "A car service is a routine check-up and maintenance process to ensure it's safe "
                    "and running smoothly. It involves a qualified mechanic inspecting the car, "
                    "checking its systems, and making adjustments or replacements as needed.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            // Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(context, "Decline"),
                  _buildButton(context, "Accept"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card Builder
  Widget _buildCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ...children, // Expands the list of children inside the card
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Detail Row Builder
  Widget _buildDetailRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          const Text(":",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isLink ? const Color(0xFF001E62) : Colors.grey,
              decoration:
                  isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  // Button Builder (Fixed)
  Widget _buildButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClientIssueDetails()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF001E62),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(140, 45),
      ),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
    );
  }
}
