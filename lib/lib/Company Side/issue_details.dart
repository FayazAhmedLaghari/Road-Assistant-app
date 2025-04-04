import 'package:flutter/material.dart';
import 'client_issue_details.dart';

class IssueDetails extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const IssueDetails({super.key, required this.requestData});

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
                            Navigator.pop(context);
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
                _buildDetailRow("Vehicle Owner", requestData['owner'] ?? 'N/A'),
                _buildDetailRow("Vehicle Type", requestData['selected_vehicle'] ?? 'N/A'),
                _buildDetailRow("Vehicle No", requestData['car_no'] ?? 'N/A'),
                _buildDetailRow("Vehicle Color", requestData['car_color'] ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 16),

            // Client Service Request Card
            _buildCard(
              title: "Client Service Request",
              children: [
                _buildDetailRow("Client Issue Type", requestData['selected_service'] ?? 'N/A'),
                _buildDetailRow("Client Location", requestData['location'] ?? 'N/A', isLink: true),
                _buildDetailRow("Client Contact", requestData['contact_no'] ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 16),
            // Client Added Text Card
_buildCard(
              title: "Client Added Text",
              children: [
                _buildDetailColumn("Details", requestData['details'] ?? 'N/A'),

              ],
            ),


            // Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(context, "Message"),
                  _buildButton(context, "Call Now"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Card
  Widget _buildCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable Row for Label + Value
  Widget _buildDetailRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Text(":", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isLink ? const Color(0xFF001E62) : Colors.grey,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
 Widget _buildDetailColumn(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isLink ? const Color(0xFF001E62) : Colors.grey,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  // Button
  Widget _buildButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF001E62),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(140, 45),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
