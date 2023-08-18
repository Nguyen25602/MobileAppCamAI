//widget để hiển thị các thuộc tính
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';

class Attribute extends StatelessWidget {
  const Attribute(
      {super.key,
      required this.icon,
      required this.infomation,
      this.color = Colors.black54,
      this.style = const TextStyle(
          color: Constants.textColor,
          fontSize: FontSize.small,
          fontFamily: 'roboto',
          fontWeight: FontWeight.w400)});
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
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          infomation,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
