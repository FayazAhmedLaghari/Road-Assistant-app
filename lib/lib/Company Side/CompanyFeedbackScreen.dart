import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanyFeedbackScreen extends StatefulWidget {
  const CompanyFeedbackScreen({super.key});

  @override
  _CompanyFeedbackScreenState createState() => _CompanyFeedbackScreenState();
}

class _CompanyFeedbackScreenState extends State<CompanyFeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF001E62), Colors.white],
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 80,
                child: Text(
                  "Feedback",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
        CircleAvatar(
          backgroundColor: Color(0xFF001E62),
          radius: 40,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: Icon(Icons.business, color: Colors.black, size: 25),
          ),
        ),
      ])),
    );
  }
}
