import 'package:cloudgo_mobileapp/helper/helper_function.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/pages/main_page.dart';
import 'package:cloudgo_mobileapp/pages/welcome_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

bool _isSignedIn = false;
String token = "";
String employeeId = "";
late Map<String, dynamic> data;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    //Run the initializeApp for web
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    //Run the initializeApp for Android
    await getUserLoggedInStatus();
    // ignore: avoid_print
    print("Đã kết nối");
  }
  runApp(ChangeNotifierProvider(
      create: (context) => UserProvider(), child: const MyApp()));
}

getUserLoggedInStatus() async {
  await HelperFunctions.getTokenFromSF().then((value) {
    if (value != null) {
      token = value;
    }
  });
  await HelperFunctions.getEmployeeIdFromSF().then((value) {
    if (value != null) {
      employeeId = value;
    }
  });
  await checkToken(token, employeeId).then((value) {
    if (value != null) {
      if (value['success'] == "0") {
        _isSignedIn = false;
      } else {
        _isSignedIn = true;
        data = value;
      }
    } else {
      _isSignedIn = false;
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    if (_isSignedIn == true) {
      User user = User.fromMap(data);
      provider.updateUserStart(user);
    }
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        primaryColor: Constants.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const MainPage() : const WelcomePage(),
    );
  }
}
