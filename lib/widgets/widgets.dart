import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
Future checkinStatusDialog(
    BuildContext context, String status, String name) async {
  String imageAssets = "";
  String text = "";
  String text2 = "";
  if (name == "WIFI") {
    imageAssets =
        status == "0" ? "assets/wifiDisconnect.json" : "assets/success.json";
    text = status == "0" ? "Vui lòng chọn đúng WIFI !" : "Chúc mừng";
    text2 = status == "0" ? "Checkin thất bại" : "Bạn đã checkin thành công";
  }
  if (name == "GPS") {
    imageAssets = status == "0" ? "assets/error.json" : "assets/success.json";
    text = status == "0" ? "Vui lòng di chuyển đến Công Ty" : "Chúc mừng";
    text2 = status == "0"
        ? "Checkin thất bại - Khoảng cách xa"
        : "Bạn đã checkin thành công";
  }

  if (name == "CameraDevice") {
    imageAssets = status == "0" ? "assets/error.json" : "assets/success.json";
    text = status == "0" ? "Quá trình check-in thất bại" : "Chúc mừng";
    text2 = status == "0"
        ? "Vui lòng thử lại hoặc thử cách khác"
        : "Bạn đã checkin thành công";
  }

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
            Lottie.asset(imageAssets, animate: true),
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

// Using Dialog Show Action Check-In
Future showCheckError(BuildContext context) async {
  String imageAssets = "";
  String text = "WIFI và GPS không đủ yêu cầu!!!";
  String text2 = "Vui lòng di chuyển đến công ty";

  imageAssets = "assets/error.json";

  Color color = Colors.red;
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
            Lottie.asset(imageAssets, animate: true),
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
