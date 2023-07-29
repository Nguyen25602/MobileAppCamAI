import 'dart:async';
import 'package:cloudgo_mobileapp/pages/login_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _SignupPageState();
}

class _SignupPageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset("assets/big_logo.png")],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            child: const Text(
              "Giải pháp chuyển đổi số toàn diện cho tiếp thị, bán hàng và chăm sóc khách hàng",
              style: TextStyle(
                  fontSize: 16,
                  color: Constants.textColor,
                  fontFamily: "roboto",
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Designed by DevTeam8 v1.0.0",
              style: TextStyle(
                  color: Constants.textColor,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
