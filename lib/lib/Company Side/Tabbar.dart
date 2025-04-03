import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Personality_Identity.dart';
import 'ServiceProvide.dart';
import 'Track.dart';
import 'tow_service.dart';

class Hometab extends StatefulWidget {
  final String companyAddress;

  Hometab({required this.companyAddress});

  @override
  _HometabState createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  int _selectedIndex = 0;
  String? companyAddress;
  String? loginTime;
  bool isAvailable = true; // Track availability state
  final List<Widget> _pages = [
    TowServiceScreen(),
    ServiceProvide(),
    Track(),
    PersonalIdentity()
  ];
  @override
  void initState() {
    super.initState();
    _fetchCompanyLocation();
  }

  Future<void> _fetchCompanyLocation() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (uid.isNotEmpty) {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('Company').doc(uid).get();
      if (doc.exists) {
        setState(() {
          companyAddress = doc["address"] ?? "Location not available";
          loginTime =
              (doc["lastLoginTime"] as Timestamp?)?.toDate().toString() ??
                  "Time not available";
        });
      }
    }
  }

  void _toggleAvailability() {
    setState(() {
      isAvailable = !isAvailable;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildLocationHeader(),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFF001E62),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.home_repair_service, "Service", 1),
          _buildNavItem(Icons.directions_car, "Track", 2),
          _buildNavItem(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on,
                  color: isAvailable ? Color(0xFF001E62) : Colors.grey),
              SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAvailable
                        ? (widget.companyAddress ?? "Fetching location...")
                        : "Unavailable",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isAvailable ? Colors.black : Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 14,
                          color: isAvailable ? Colors.grey : Colors.grey[400]),
                      SizedBox(width: 4),
                      Text(
                        isAvailable
                            ? (loginTime ?? "09:00 AM - 5:00 PM")
                            : "Unavailable",
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                isAvailable ? Colors.grey : Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: InkWell(
              onTap: _toggleAvailability,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                decoration: BoxDecoration(
                  color: isAvailable ? Color(0xFF001E62) : Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isAvailable ? "Available" : "Unavailable",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              _selectedIndex == index ? Color(0xFF001E62) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: _selectedIndex == index ? Colors.white : Color(0xFF001E62),
            ),
            if (_selectedIndex == index)
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
      label: '',
    );
  }
}
