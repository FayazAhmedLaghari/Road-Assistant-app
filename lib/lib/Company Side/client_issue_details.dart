import 'package:flutter/material.dart';

class ClientIssueDetails extends StatelessWidget {
  final String carNo;
  final String selectedVehicle;
  final String carColor;
  final String selectedService;

  const ClientIssueDetails({
    Key? key,
    required this.carNo,
    required this.selectedVehicle,
    required this.carColor,
    required this.selectedService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xFF001E62), Colors.white],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(alignment: Alignment.center, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () => Scaffold.of(context).openDrawer(),
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
            _buildCard(
              title: "Vehicle Details",
              children: [
                _buildDetailRow("Vehicle No", carNo),
                _buildDetailRow("Vehicle Type", selectedVehicle),
                _buildDetailRow("Vehicle Color", carColor),
              ],
            ),
            _buildCard(
              title: "Service Requested",
              children: [
                _buildDetailRow("Service Type", selectedService),
              ],
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
          child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
          Text(":"),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
        ],
      ),
    );
  }
}
