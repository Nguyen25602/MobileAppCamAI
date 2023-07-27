import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';

class Attribute extends StatelessWidget {
  const Attribute(
    {super.key, 
    required this.icon, 
    required this.infomation, 
    this.color =const Color.fromARGB(132, 156, 153, 153), 
    this.style =const TextStyle(
      color: Constants.textColor,
      fontSize: 12,
      fontFamily: 'roboto',
      fontWeight: FontWeight.w300
    )});
  final Color color;
  final IconData icon;
  final String infomation;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: color,),
        const SizedBox(width: 5,),
        Text(
          infomation,
          style: style,
        )
      ],
    );
  }
}