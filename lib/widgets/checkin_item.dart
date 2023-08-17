import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/list_item.dart';
import 'package:cloudgo_mobileapp/widgets/list_item_attribute.dart';
import 'package:flutter/material.dart';

class CheckInItem extends StatelessWidget {
  const CheckInItem({super.key, required CheckIn item}) : _item = item;
  final CheckIn _item;
  @override
  Widget build(BuildContext context) {
    return ListItem(attributes: [
      Attribute(
        icon: Icons.access_time_outlined,
        infomation: _item.time,
        color: Constants.enableButton,
        style: const TextStyle(
          fontFamily: 'roboto',
          color: Constants.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      Attribute(
          icon: Icons.devices_other_outlined,
          infomation: _item.device.formatString)
    ]);
  }
}
