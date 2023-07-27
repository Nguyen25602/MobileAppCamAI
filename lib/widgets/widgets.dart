import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var textInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.all(10),
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

class IconWidgets extends StatefulWidget {
  final IconData iconPath;
  final String text;
  final VoidCallback? onPressed;
  final Color vcolor;
  final bool enable;

  const IconWidgets({
    Key? key,
    required this.iconPath,
    required this.text,
    // ignore: avoid_init_to_null
    this.onPressed = null,
    this.vcolor = Colors.white,
    this.enable = false,
  }) : super(key: key);

  @override
  State<IconWidgets> createState() => _IconWidgetsState();
}

class _IconWidgetsState extends State<IconWidgets> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.enable ? null : widget.onPressed,
        child: widget.onPressed != null
            ? Column(
                children: [
                  FaIcon(
                    widget.iconPath,
                    size: 24,
                    color: Constants.textColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(color: Constants.textColor, fontSize: 12),
                  )
                ],
              )
            : Column(
                children: [
                  FaIcon(
                    widget.iconPath,
                    size: 24,
                    color: Constants.enableButton,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.text,
                    style:
                        TextStyle(color: Constants.enableButton, fontSize: 12),
                  )
                ],
              ));
  }
}
