import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  const Profile(
      {super.key, required this.accountName, required this.accountEmail});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1.5,
      widthFactor: 5,
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Container(
            height: 100,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Icon(
                Icons.person,
                size: 30,
                color: Color(0xFF001E62),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(accountName, style: TextStyle(color: Colors.white)),
              Text(accountEmail, style: TextStyle(color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}
