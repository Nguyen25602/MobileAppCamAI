import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/list_item.dart';
import 'package:cloudgo_mobileapp/widgets/list_item_attribute.dart';
import 'package:flutter/material.dart';

class TimeKeepingItem extends StatefulWidget {
  const TimeKeepingItem({super.key, required TimeKeeping timeKeeping})
      : _timeKeeping = timeKeeping;
  final TimeKeeping _timeKeeping;
  @override
  State<TimeKeepingItem> createState() => _TimeKeepingItemState();
}

class _TimeKeepingItemState extends State<TimeKeepingItem> {
  @override
  Widget build(BuildContext context) {
    return ListItem(attributes: [
      Attribute(
        icon: Icons.calendar_month_outlined,
        infomation: widget._timeKeeping.day,
        color: Constants.enableButton,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: 'roboto',
            color: Constants.textColor),
      ),
      Attribute(
          icon: Icons.location_on_outlined,
          infomation: widget._timeKeeping.timeCheckIn),
      Attribute(
          icon: Icons.access_time_outlined,
          infomation: '${widget._timeKeeping.workTime} hours'),
      Attribute(
          icon: Icons.output_outlined,
          infomation: widget._timeKeeping.timeCheckOut),
      Attribute(
          icon: Icons.devices_other_outlined,
          infomation: widget._timeKeeping.deviceCheckIn)
    ]);
  }
}
