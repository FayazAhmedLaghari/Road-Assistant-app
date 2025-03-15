import 'package:flutter/material.dart';

class BuildRequestCard extends StatelessWidget {
  const BuildRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[300],
                    )),
                Center(
                  child: Icon(
                    Icons.notifications_sharp,
                    size: 150,
                    color: Color(0xFF001E62),
                  ),
                ),
                Center(
                    child: Text(
                  'You have 1 request to\n repair',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )),
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Details',
                          style: TextStyle(
                              color: Color(0xFF001E62),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ))),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color(0xFF001E62)),
                    child: Text("Decline",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xFF001E62), width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Accept",
                        style: TextStyle(
                          color: Color(0xFF001E62),
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mr. Wesilewski",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Car | Toyota | Innova | Petrol | DL 01 MN 5832",
                  style: TextStyle(color: Colors.grey[700])),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF001E62)),
                    child:
                        Text("Decline", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF001E62)),
                    child:
                        Text("Accept", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
