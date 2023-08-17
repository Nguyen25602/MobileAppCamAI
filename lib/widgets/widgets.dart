import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';

var textInputDecoration = const InputDecoration(
  contentPadding: EdgeInsets.all(10),
  labelStyle:
      TextStyle(color: Constants.textColor, fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants.successfulColor, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants.enableButton, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants.dangerousColor, width: 2),
  ),
);

void clearAllSnackBars(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
}

void removeCurrentSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenRemove(context, page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

// Show Detail App Bar
void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 12),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    duration: const Duration(seconds: 10),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}

// Checkin Success || Error
Future checkinStatusDialog(BuildContext context, String status) async {
  String imageAssets =
      status == "0" ? "assets/error_checkin.jpg" : "assets/success_checkin.png";
  String text = status == "0" ? "Có lỗi xảy ra !" : "Chúc mừng";
  String text2 =
      status == "0" ? "Checkin thất bại" : "Bạn đã checkin thành công";
  Color color = status == "0" ? Colors.red : Constants.successfulColor;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(imageAssets),
            ),
            const SizedBox(
              height: MarginValue.small,
            ),
            Text(
              text,
              style: TextStyle(fontSize: FontSize.veryLarge, color: color),
              textAlign: TextAlign.center,
            ),
            Text(
              text2,
              style: TextStyle(fontSize: FontSize.large, color: color),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    },
  );
}
