import 'package:cloudgo_mobileapp/object/timekeeping.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Table(
          children: [
            TableRow(children: [
              TableCell(
                child: labelWithInformation("Date", widget._timeKeeping.day),
              ),
              TableCell(
                  child: labelWithInformation(
                      'Device', widget._timeKeeping.deviceCheckIn)),
              const SizedBox(),
            ]),
            TableRow(children: [
              SizedBox(
                height: MarginValue.small,
              ),
              SizedBox(
                height: MarginValue.small,
              ),
              const Icon(Icons.av_timer_outlined)
            ]),
            TableRow(children: [
              TableCell(
                  child: labelWithInformation(
                      "CheckIn", widget._timeKeeping.timeCheckIn)),
              TableCell(
                  child: labelWithInformation(
                      "CheckOut", widget._timeKeeping.timeCheckOut)),
              const SizedBox(),
            ])
          ],
        )
      ],
    );
  }

  Text label(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFF17030),
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        letterSpacing: 0.30,
      ),
    );
  }

  Text information(String infor) {
    return Text(
      infor,
      style: TextStyle(
        color: Constants.textColor,
        fontSize: 12,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        letterSpacing: 0.30,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget labelWithInformation(String title, String infor, {double margin = 0}) {
    return Container(
      margin: EdgeInsets.only(left: margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(title),
          information(infor),
        ],
      ),
    );
  }
}
