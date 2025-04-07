import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IssueDetails extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const IssueDetails({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No client issues found."));
          }
          var issueData = snapshot.data!.docs.first;

          // Fetching user details (assuming 'user_id' is available in requestData)
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(issueData['user_id']) // Replace 'user_id' with the actual field
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError) {
                return Center(child: Text("Error: ${userSnapshot.error}"));
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(child: Text("User not found"));
              }

              var userData = userSnapshot.data!.data() as Map<String, dynamic>;
              String vehicleOwner = userData['name'] ?? 'Unknown Owner'; // Assuming 'name' field exists in 'users' collection

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    _buildCard(
                      title: "Vehicle Details",
                      children: [
                        _buildDetailRow("Vehicle Owner", vehicleOwner), // Displaying vehicle owner's name
                        _buildDetailRow("Vehicle Type", issueData['selected_service']),
                        _buildDetailRow("Vehicle Name", issueData['selected_vehicle']),
                        _buildDetailRow("Vehicle Color", issueData['car_color']),
                      ],
                    ),
                    _buildCard(
                      title: "Client Service Request",
                      children: [
                        _buildDetailRow("Client Issue Type", issueData['details']),
                        _buildDetailRow("Client Location", issueData['location'], isLink: true),
                        _buildDetailRow("Client Contact", issueData['contact_no']),
                      ],
                    ),
                    _buildCard(
                      title: "Client Added Text",
                      children: [
                        const Text(
                          "description :",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            issueData['details'] ?? "No description provided.",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        _buildButtons(context),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
            const Text(
              "Client Issue Details",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
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
                children: [const SizedBox(height: 8), ...children],
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

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButtonDec(context, "Decline"),
          _buildButtonAce(context, "Accept"),
        ],
      ),
    );
  }

  Widget _buildButtonDec(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () async {
        var snapshot = await FirebaseFirestore.instance.collection('requests').get();
        if (snapshot.docs.isNotEmpty) {
          var doc = snapshot.docs.first;
          var docId = doc.id;

          // Firestore se request delete karo
          await FirebaseFirestore.instance
              .collection('requests')
              .doc(docId)
              .delete();

          // Snackbar show karo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request removed')),
          );

          // Pop back to previous screen
          Navigator.pop(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF001E62),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(140, 45),
      ),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
    );
  }

  Widget _buildButtonAce(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () async {
        // Fetch first document from requests collection (just as in your builder)
        var snapshot = await FirebaseFirestore.instance.collection('requests').get();
        if (snapshot.docs.isNotEmpty) {
          var doc = snapshot.docs.first;
          var data = doc.data();
          var docId = doc.id;

          // Add to company's service_requests collection
          await FirebaseFirestore.instance
              .collection('Company')
              .doc("YOUR_COMPANY_ID") // Replace with your actual company ID
              .collection('service_requests')
              .doc(docId)
              .set({
                ...data,
                'timestamp': FieldValue.serverTimestamp(),
                'status': 'Accepted'
              });

          // Optionally, update the status in original document
          await FirebaseFirestore.instance
              .collection('requests')
              .doc(docId)
              .update({'status': 'Accepted'});

          // Show a confirmation message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Client request has been accepted.')),
          );

          Navigator.pop(context); // Or navigate to Track screen
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF001E62),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(140, 45),
      ),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
    );
  }
}
