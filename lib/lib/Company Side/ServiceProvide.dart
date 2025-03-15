import 'package:flutter/material.dart';

import 'CompanyNotification.dart';
import 'Drawer.dart';

class ServiceProvide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF001E62), Colors.white],
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CompanyNotificationsScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Service Provide For",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _serviceType("Car", "assets/car.png", true),
              _serviceType("MotorCycle", "assets/motorcycle.png", true),
              _serviceType("Rickshaw", "assets/rickshaw.png", true),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Service",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _serviceCard("Flat tire", Icons.tire_repair, true, true),
                _serviceCard(
                    "Towing Service", Icons.local_shipping, true, true),
                _serviceCard("Engine Heat", Icons.warning, true, true),
                _serviceCard("Battery Jump Start", Icons.battery_charging_full,
                    true, true),
                _serviceCard("Key Lock", Icons.vpn_key, true, true),
                _serviceCard("Engine Check", Icons.settings, true, true),
              ],
            ),
          )
        ],
      ),
      drawer: CompanyDrawer(),
    );
  }

  Widget _serviceType(String title, String imagePath, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected ? Color(0xFF001E62) : Colors.grey, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(Icons.check_circle, color: Colors.grey, size: 22),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Color(0xFF001E62) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _serviceCard(
      String title, IconData icon, bool isSelected, bool isWhiteBg) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isWhiteBg ? Colors.white : Color(0xFF001E62),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF001E62),
                  radius: 35,
                  child: Icon(icon, size: 35, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isWhiteBg ? Color(0xFF001E62) : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: Colors.grey, size: 22),
              ),
          ],
        ),
      ),
    );
  }
}
