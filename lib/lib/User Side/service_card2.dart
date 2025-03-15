import 'package:flutter/material.dart';

class BuildServiceCard extends StatelessWidget {
  final String title;
  final String address;
  final double rating;
  const BuildServiceCard(
      {super.key,
      required this.title,
      required this.address,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Side - Car Icon
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.directions_car,
                  size: 40, color: Color(0xFF001E62)),
            ),
            const SizedBox(width: 12),
            // Middle - Service Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time & Business Name
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled,
                          size: 16, color: Colors.black),
                      const SizedBox(width: 4),
                      const Text(
                        "9am - 5pm",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Right Side - Rating
            Row(
              children: [
                const Icon(Icons.star, size: 18, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
