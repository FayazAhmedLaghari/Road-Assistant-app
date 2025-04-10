import 'package:firebase_app/lib/User%20Side/HelpSupport.dart';
import 'package:flutter/material.dart';
import 'Changepassword.dart';
import 'Register.dart';
import 'Request/Feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF001E62), Colors.white],
              ),
            ),
            child: Stack(alignment: AlignmentDirectional.center, children: [
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
                  "Settings",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xFF001E62),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF001E62)),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        activeColor: Color(0xFF001E62),
                        value: isNotificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            isNotificationsEnabled = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                buildSettingsButton('Change Password', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  );
                }),
                SizedBox(height: 30),
                buildSettingsButton('Help & Feedback', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpSupportScreen()),
                  );
                }),
                SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final auth = FirebaseAuth.instance;
                      final firestore = FirebaseFirestore.instance;
                      final user = auth.currentUser;

                      if (user != null) {
                        print("User found: ${user.uid}");

                        try {
                          await firestore
                              .collection('users')
                              .doc(user.uid)
                              .delete();
                          print("User document deleted from Firestore");

                          await user.delete();
                          print("User deleted from FirebaseAuth");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Account deleted successfully")),
                          );

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()),
                            (route) => false,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'requires-recent-login') {
                            print("Requires recent login");

                            _showReauthDialog(context, user.email!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${e.message}")),
                            );
                          }
                        } catch (e) {
                          print("Error: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(width: 1, color: Colors.red),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettingsButton(String text, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xFF001E62),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
              fontSize: 18,
              color: Color(0xFF001E62),
              fontWeight: FontWeight.w600),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Color(0xFF001E62),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showReauthDialog(BuildContext context, String email) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Re-authenticate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please enter your password to continue.'),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: () async {
                final password = passwordController.text.trim();
                Navigator.pop(context);

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  final cred = EmailAuthProvider.credential(
                      email: email, password: password);

                  await user!.reauthenticateWithCredential(cred);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .delete();
                  await user.delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Account deleted successfully")),
                  );

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()),
                    (route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.message}")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
