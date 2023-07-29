import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/checkin_item.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:intl/intl.dart';

class CheckinHistory extends StatefulWidget {
  const CheckinHistory({super.key, required DateTime day}) : _day = day;
  final DateTime _day;

  @override
  State<CheckinHistory> createState() => _CheckinHistoryState();
}

class _CheckinHistoryState extends State<CheckinHistory> {
  Future<List<CheckIn>> getRequest(DateTime day) async {
    return Future.delayed(
      const Duration(seconds: 5),
      () {
        List<CheckIn> items = [];
        for (var element in temp) {
          if (isSameDay(day, element.dateTime)) {
            items.add(element);
          }
        }
        return items;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          "LỊCH SỬ CHECKIN",
          style: TextStyle(
              color: Constants.textColor,
              fontSize: 18,
              fontFamily: 'roboto',
              fontWeight: FontWeight.w700),
        ),
      ),
      body: FutureBuilder(
        future: getRequest(widget._day),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("There is something wrong"),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "There are no match data for that day",
                  style: TextStyle(
                    color: Constants.textColor,
                    fontFamily: 'roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.all(MarginValue.medium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF008ECF), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                    child: Text(DateFormat("dd/MM/yyyy").format(widget._day),
                        style: const TextStyle(
                            color: Color(0xFF008ECF),
                            fontSize: 14,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: height / 2,
                    child: ListView.separated(
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Constants.lineColor,
                      ),
                      itemBuilder: (context, index) {
                        return checkInItem(item: snapshot.data![index]);
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  List<CheckIn> temp = [
    CheckIn(date: DateTime(2023, 7, 19, 7, 30), device: TypeDevice.gps),
    CheckIn(date: DateTime(2023, 7, 19, 10, 30), device: TypeDevice.camera),
    CheckIn(date: DateTime(2023, 7, 19, 14, 30), device: TypeDevice.wifi),
    CheckIn(date: DateTime(2023, 7, 19, 17, 30), device: TypeDevice.camera),
    CheckIn(date: DateTime(2023, 7, 20, 10, 30), device: TypeDevice.camera),
    CheckIn(date: DateTime(2023, 7, 20, 14, 30), device: TypeDevice.wifi),
    CheckIn(date: DateTime(2023, 7, 20, 17, 30), device: TypeDevice.camera),
  ];
}
