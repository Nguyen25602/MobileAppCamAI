import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:cloudgo_mobileapp/pages/checkcamera_page.dart';
import 'package:cloudgo_mobileapp/pages/home_page.dart';
import 'package:cloudgo_mobileapp/pages/login_page.dart';
import 'package:cloudgo_mobileapp/pages/notification_page.dart';
import 'package:cloudgo_mobileapp/pages/request_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    //Run the initializeApp for web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    //Run the initializeApp for Android
    await Firebase.initializeApp();
    // ignore: avoid_print
    print("Đã kết nối");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: NotificationPage()
    );
  }
}
