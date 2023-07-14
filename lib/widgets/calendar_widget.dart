import 'package:cloudgo_mobileapp/pages/event.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class CalendarWidget extends StatefulWidget {
  CalendarWidget({super.key, this.selectedMonth});
  int? selectedMonth = DateTime.now().month;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  int _hellocuccung(DateTime date) {
    final events = selectedEvents[date];
    if (events != null && events.isNotEmpty) {
      return events[0].checkInOutData['status'];
    }
    return 0; // Mặc định là status = 0
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  final checkInOutData = {
    DateTime.utc(2023, 07, 03): [
      Event(checkInOutData: {
        'checkIn': '09:00 AM',
        'status': 1,
      }),
      Event(checkInOutData: {
        'checkIn': '10:00 AM',
        'status': 1,
      }),
      Event(checkInOutData: {
        'checkIn': '17:00 PM',
      }),
    ],
    DateTime.utc(2023, 07, 04): [
      Event(checkInOutData: {
        'checkIn': '09:00 AM',
        'status': 1,
      }),
      Event(checkInOutData: {
        'checkIn': '10:00 AM',
        'status': 1,
      }),
      Event(checkInOutData: {
        'checkIn': '17:00 PM',
        'status': 1,
      }),
    ],
    DateTime.utc(2023, 07, 05): [
      Event(checkInOutData: {
        'checkIn': '5:00 AM',
        'status': 0,
      }),
      Event(checkInOutData: {
        'checkIn': '10:00 AM',
        'status': 1,
      }),
      Event(checkInOutData: {
        'checkIn': '17:00 PM',
        'status': 0,
      }),
    ],
    // Thêm các ngày khác tại đây (nếu cần)
  };
  late Map<DateTime, List<Event>> selectedEvents =
      checkInOutData.cast<DateTime, List<Event>>();
  // Khởi tạo ngày Check-In
  @override
  Widget build(BuildContext context) {
    if (widget.selectedMonth != null) {
      setState(() {
        focusedDay = DateTime(DateTime.now().year, widget.selectedMonth!);
      });
    }
    return SizedBox(
      child: TableCalendar(
        availableCalendarFormats: const {
          CalendarFormat.month: "Tháng",
          CalendarFormat.twoWeeks: "2 Tuần",
          CalendarFormat.week: "Tuần"
        },
        rowHeight: 45,
        focusedDay: focusedDay,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        calendarFormat: format,
        onFormatChanged: (CalendarFormat a) {
          setState(() {
            format = a;
          });
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekVisible: true,

        //Day Changed
        onDaySelected: (DateTime selectDay, DateTime focusDay) {
          setState(() {
            selectedDay = selectDay;
            // ignore: avoid_print
            print(selectedDay);
            focusedDay = focusDay;
          });
        },
        // Style màu sắc + chữ trong Calendar //
        calendarStyle: CalendarStyle(
          markersAlignment: Alignment.bottomCenter,
          markersMaxCount: 4,
          rangeEndTextStyle: const TextStyle(color: Colors.blue),
          // Style Text Khi Chọn //
          selectedTextStyle:
              TextStyle(color: Constants.whiteTextColor, fontSize: 14),
          // Style Text Khi Chọn //
          // Hiển Thị Today //
          isTodayHighlighted: true,
          todayTextStyle:
              TextStyle(color: Constants.whiteTextColor, fontSize: 14),
          // Style Today //
          todayDecoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          // Style Ngày chọn //
          selectedDecoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          withinRangeDecoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          rangeHighlightColor: const Color.fromARGB(255, 74, 255, 33),
          // Style Text Ngày cuối tuần //
          weekendTextStyle: TextStyle(
              color: Constants.warningColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
          // Style Text Ngày Lễ //
          defaultTextStyle: TextStyle(
              color: Constants.textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Constants.textColor)),
        headerStyle: HeaderStyle(
          leftChevronIcon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: Constants.textColor,
            size: 14,
          ),
          rightChevronIcon: FaIcon(
            FontAwesomeIcons.chevronRight,
            color: Constants.textColor,
            size: 14,
          ),
          // Button Format
          titleCentered: true, // Text Date nằm giữa
          formatButtonShowsNext: false, //Ngăn không cho Format Show trước
          //Title Header Calendar Style
          titleTextStyle: TextStyle(
              color: Constants.textColor,
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
              fontSize: 14),
          formatButtonDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0),
          ),
          formatButtonTextStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        selectedDayPredicate: (DateTime date) {
          return isSameDay(selectedDay, date);
        },
        eventLoader: _getEventsfromDay,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final status = _hellocuccung(day);
            final List<Widget> markers = [];
            if (status == 1) {
              markers.add(Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5.5),
                width: 5,
                height: 5,
              ));
            }
            if (status == 2) {
              markers.add(Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                width: 5,
                height: 5,
              ));
            }
            return Column(
              children: markers,
            );
          },
        ),
      ),
    );
  }
}
