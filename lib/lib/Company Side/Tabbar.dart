import 'package:flutter/material.dart';
import 'Personality_Identity.dart';
import 'ServiceProvide.dart';
import 'Track.dart';
import 'tow_service.dart';

class Hometab extends StatefulWidget {
  @override
  _HometabState createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  int _selectedIndex = 0; // Default selected index
  final List<Widget> _pages = [
    TowServiceScreen(),
    ServiceProvide(),
    Track(),
    PersonalIdentity()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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

Widget _buildServiceCategory(String title, IconData icon) {
  return Column(
    children: [
      Icon(icon, size: 40, color: Color(0xFF001E62)),
      SizedBox(height: 5),
      Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
    ],
  );
}

Widget _buildServiceTile(String title, IconData icon, bool selected) {
  return Container(
    decoration: BoxDecoration(
      color: selected ? Color(0xFF001E62) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Color(0xFF001E62), width: 1),
    ),
    padding: EdgeInsets.all(10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            size: 40, color: selected ? Colors.white : Color(0xFF001E62)),
        SizedBox(height: 5),
        Text(title,
            style: TextStyle(
                color: selected ? Colors.white : Color(0xFF001E62),
                fontWeight: FontWeight.bold))
      ],
    ),
  );
}
