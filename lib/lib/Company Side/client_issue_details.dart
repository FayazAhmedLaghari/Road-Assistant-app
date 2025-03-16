import 'package:flutter/material.dart';

class ClientIssueDetails extends StatelessWidget {
  const ClientIssueDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background similar to the image
      body: SingleChildScrollView(
        // ✅ Added ScrollView to prevent overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xFF001E62), Colors.white])),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(alignment: Alignment.center, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Positioned(
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
                ]),
              ),
            ),

            // Vehicle Details Card
            _buildCard(
              title: "Vehicle Details",
              children: [
                _buildDetailRow("Vehicle Owner", "Mr. Weslewski"),
                _buildDetailRow("Vehicle Type", "Car"),
                _buildDetailRow("Vehicle Name", "Toyota"),
                _buildDetailRow("Vehicle Color", "Petrol"),
              ],
            ),

            SizedBox(height: 16),

            // Client Service Request Card
            _buildCard(
              title: "Client Service Request",
              children: [
                _buildDetailRow("Client Issue Type", "Flat Tyre"),
                _buildDetailRow("Client Location", "Locate Client",
                    isLink: true),
                _buildDetailRow("Client Contact", "02....")
              ],
            ),

            SizedBox(height: 16),

            // Client Added Text Card
            _buildCard(
              title: "Client Added Text",
              children: [
                Text(
                  "Description :",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "A car service is a routine check-up and maintenance process to ensure it's safe "
                    "and running smoothly. It involves a qualified mechanic inspecting the car, "
                    "checking its systems, and making adjustments or replacements as needed.",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton("Decline", Colors.white, Color(0xFF001E62)),
                  _buildButton("Accept", Color(0xFF001E62), Colors.white),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                  SizedBox(height: 8),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          Text(":",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          Text(
            value,
            style: TextStyle(
              fontSize: 1,
              fontWeight: FontWeight.w500,
              color: isLink ? Color(0xFF001E62) : Colors.grey,
              decoration:
                  isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color color, Color textColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        side: BorderSide(width: 1, color: Color(0xFF001E62)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size(140, 45),
      ),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
    );
  }
}
