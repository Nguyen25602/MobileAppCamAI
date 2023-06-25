import 'package:flutter/material.dart';

class IconWidgets extends StatefulWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;
  final Color vcolor;

  const IconWidgets({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
    required this.vcolor,
  }) : super(key: key);

  @override
  State<IconWidgets> createState() => _IconWidgetsState();
}

class _IconWidgetsState extends State<IconWidgets> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          onPressed: widget.onPressed,
          color: widget.vcolor,
          textColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: const CircleBorder(),
          child: Image.asset(widget.iconPath),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          widget.text,
          style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
      ],
    );
  }
}
