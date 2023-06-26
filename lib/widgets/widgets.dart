import 'package:flutter/material.dart';

class IconWidgets extends StatefulWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;
  final Color vcolor;
  final bool isText;

  const IconWidgets({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
    required this.vcolor,
    this.isText = false,
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
        Stack(children: [
          MaterialButton(
            onPressed: widget.onPressed,
            color: widget.vcolor,
            textColor: Colors.white,
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(),
            child: Image.asset(widget.iconPath),
          ),
          if (widget.isText)
            Positioned(
              top: 0, // Vị trí top của hình tròn thông báo
              right: 8, // Vị trí right của hình tròn thông báo
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white, // Màu sắc của hình tròn thông báo
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '10', // Số lượng thông báo
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ]),
        const SizedBox(
          height: 15,
        ),
        Text(
          widget.text,
          style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 10),
        ),
      ],
    );
  }
}
