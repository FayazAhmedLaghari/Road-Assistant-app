import 'package:flutter/material.dart';

class ClientIssueDetails extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const ClientIssueDetails({
    Key? key,
    required this.requestData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
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
                          onPressed: () => Navigator.pop(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 58,
                      child: Text(
                        "Client Issue Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Vehicle Details
            _buildCard(
              title: "Vehicle Details",
              children: [
                _buildDetailRow("Owner Name", requestData['owner'] ?? 'N/A'),
                _buildDetailRow("Vehicle No", requestData['car_no'] ?? 'N/A'),
                _buildDetailRow("Vehicle Type", requestData['selected_vehicle'] ?? 'N/A'),
                _buildDetailRow("Vehicle Color", requestData['car_color'] ?? 'N/A'),
              ],
            ),

            // Service Details
            _buildCard(
              title: "Service Requested",
              children: [
                _buildDetailRow("Service Type", requestData['selected_service'] ?? 'N/A'),
                _buildDetailRow("Location", requestData['location'] ?? 'N/A'),
                _buildDetailRow("Client Contact", requestData['contact_no'] ?? 'N/A'),
              ],
            ),

            // Extra Notes / Details
            _buildCard(
              title: "Additional Notes",
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

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
          const Text(":"),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey)),
        ],
      ),
    );
  }
}
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


