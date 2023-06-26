import 'package:flutter/material.dart';

class Constants {
  // static String appId = "1:815703663399:web:70fb9cffda63fa33b77f02";
  // static String apiKey = "AIzaSyAL7sJb40hWnbvCdMg1axiTNfQZlUj1lsM";
  // static String messagingSenderId = "815703663399";
  // static String projectId = "chatapp-67336";
  final primaryColor = const Color(0xff3a4869);
}

Future<void> dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        widthFactor: 1,
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          alignment: Alignment.topCenter,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: const SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(image: AssetImage("assets/Logo_CloudGo.png")),
                Icon(Icons.close),
              ],
            ),
          ),
          content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Button 1'),
                  onPressed: () {
                    // Hành động khi nhấn Button 1
                  },
                ),
                ElevatedButton(
                  child: Text('Button 2'),
                  onPressed: () {
                    // Hành động khi nhấn Button 2
                  },
                ),
                ElevatedButton(
                  child: Text('Button 3'),
                  onPressed: () {
                    // Hành động khi nhấn Button 3
                  },
                ),
              ]),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
