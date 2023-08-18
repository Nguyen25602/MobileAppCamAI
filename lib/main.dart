import 'package:cloudgo_mobileapp/helper/helper_function.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/pages/main_page.dart';
import 'package:cloudgo_mobileapp/pages/welcome_page.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/repository/NotificationRepository.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

bool? isSigned;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Run the initializeApp for Android
  // Khởi tạo Firebase
  await Firebase.initializeApp();
  // await getUserLoggedInStatus();
  // ignore: avoid_print
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CheckinRepository.create(),
    ),
    ChangeNotifierProvider(
      create: (context) => RequestRepository.create(),
    ),
    ChangeNotifierProvider(
      create: (context) => NotificationRepository.create(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool?> isUserLogin() async {
    isSigned = await HelperFunctions.getUserLoggedInStatus();
    return isSigned;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: GoogleFonts.roboto().fontFamily,
          primaryColor: Constants.primaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: isUserLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return const MainPage();
              }
            }
            return const WelcomePage();
          },
        ));
  }
}
