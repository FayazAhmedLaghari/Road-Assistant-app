import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final String imageUrl =
      'https://your_image_link_here.com'; // Replace with actual image URL

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roadside Assistance 24'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(imageUrl, height: 120), // App Logo
            const SizedBox(height: 10),
            Text(
              'Roadside Assistance 24 v.2.4.3',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _launchURL('https://playstore_link_here.com'),
              child: Text('Rate this app'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _launchURL('https://www.roadsideassistance24.com'),
              child: Text(
                'www.roadsideassistance24.com',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => _launchURL('mailto:add@roadsideassistance24.com'),
              child: Text(
                'add@roadsideassistance24.com',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => _launchURL('https://provider_signup_link.com'),
              child: Text(
                'Become a provider',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => _launchURL('https://privacy_policy_link.com'),
              child: Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            Spacer(),
            Text(
              '© Pavel Ananyev, 2012-2025',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
