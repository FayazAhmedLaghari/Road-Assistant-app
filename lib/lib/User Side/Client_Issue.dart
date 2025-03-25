import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientIssueForm extends StatefulWidget {
  @override
  _ClientIssueFormState createState() => _ClientIssueFormState();
}

class _ClientIssueFormState extends State<ClientIssueForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ownerController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController issueTypeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _firestore.collection('client_issues').add({
        'vehicle_owner': ownerController.text,
        'vehicle_type': vehicleTypeController.text,
        'vehicle_name': vehicleNameController.text,
        'vehicle_color': vehicleColorController.text,
        'client_issue_type': issueTypeController.text,
        'client_location': locationController.text,
        'client_contact': contactController.text,
        'description': descriptionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Form Submitted Successfully")),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit form: $error")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Client Issue Form"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Vehicle Details"),
                _buildTextField("Vehicle Owner", ownerController),
                _buildTextField("Vehicle Type", vehicleTypeController),
                _buildTextField("Vehicle Name", vehicleNameController),
                _buildTextField("Vehicle Color", vehicleColorController),
                SizedBox(height: 10),
                _buildSectionTitle("Client Service Request"),
                _buildTextField("Client Issue Type", issueTypeController),
                _buildTextField("Client Location", locationController),
                _buildTextField("Client Contact", contactController),
                SizedBox(height: 10),
                _buildSectionTitle("Additional Details"),
                _buildDescriptionField("description", descriptionController),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDescriptionField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent),
      ),
    );
  }
}
