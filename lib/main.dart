import 'package:firebase_app/firebase_options.dart';
import 'package:firebase_app/lib/Company%20Side/SplashScreen.dart';
import 'package:firebase_app/lib/Company%20Side/Tabbar.dart';
import 'package:firebase_app/lib/Company%20Side/client_issue_details.dart';
import 'package:firebase_app/lib/Company%20Side/issue_details.dart';
import 'package:firebase_app/lib/Company%20Side/tow_service.dart';
import 'package:firebase_app/lib/User%20Side/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app/lib/Company%20Side/CompanyProfile.dart';
import 'package:firebase_app/lib/User%20Side/UserProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'lib/Company Side/Location_Picker.dart';
import 'lib/Company Side/Personality_Identity.dart';
import 'lib/Company Side/SplashScreen.dart';
import 'lib/Company Side/Tabbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).

        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: Hometab(
      //   companyAddress: '',
      // ),
      home: Splashscreen(),
    );
  }
}
