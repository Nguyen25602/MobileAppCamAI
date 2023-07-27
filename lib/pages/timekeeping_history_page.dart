import 'package:cloudgo_mobileapp/pages/checkIn_history_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/timekeeping_item.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:intl/intl.dart';

class TimekeepingHistoryPage extends StatefulWidget {
  TimekeepingHistoryPage({super.key});
  final listTimeKeepingHistory = [
    TimeKeeping(
        checkIn: DateTime.now(),
        checkOut: DateTime.now(),
        time: 8,
        typeCheckIn: TypeDevice.gps),
    TimeKeeping(
        checkIn: DateTime.now().subtract(const Duration(days: 1)),
        checkOut: DateTime.now().subtract(const Duration(days: 1)),
        time: 5,
        typeCheckIn: TypeDevice.camera),
    TimeKeeping(
        checkIn: DateTime.now().subtract(const Duration(days: 3)),
        checkOut: DateTime.now().subtract(const Duration(days: 3)),
        time: 7,
        typeCheckIn: TypeDevice.wifi),
    TimeKeeping(
        checkIn: DateTime.now().subtract(const Duration(days: 5)),
        checkOut: DateTime.now().subtract(const Duration(days: 5)),
        time: 6,
        typeCheckIn: TypeDevice.camera),
    TimeKeeping(
        checkIn: DateTime.now().subtract(const Duration(days: 2)),
        checkOut: DateTime.now().subtract(const Duration(days: 2)),
        time: 5,
        typeCheckIn: TypeDevice.gps),
  ];
  @override
  State<TimekeepingHistoryPage> createState() => _TimekeepingHistoryPageState();
}

class _TimekeepingHistoryPageState extends State<TimekeepingHistoryPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _selectedMonth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(
        user: null,
        scaffoldKey: scaffoldKey,
        titlebar: "LỊCH SỬ CHẤM CÔNG",
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2023, 1, 1),
                lastDay: DateTime(2023, 12, 30),
                calendarFormat: _format,
                rowHeight: 45,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  markersMaxCount: 1,
                  rangeEndTextStyle: TextStyle(color: Colors.blue),
                  // Style Ngày chọn //
                  selectedTextStyle:
                      TextStyle(color: Constants.whiteTextColor, fontSize: 14),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  //Style ngày hôm nay
                  todayTextStyle:
                      TextStyle(color: Constants.whiteTextColor, fontSize: 14),
                  todayDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(
                      color: Constants.warningColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  defaultTextStyle: TextStyle(
                      color: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Constants.textColor)),
                headerStyle: HeaderStyle(
                  leftChevronIcon: const FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    color: Constants.textColor,
                    size: 14,
                  ),
                  rightChevronIcon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    color: Constants.textColor,
                    size: 14,
                  ),
                  // Button Format
                  titleCentered: true, // Text Date nằm giữa
                  formatButtonVisible: false,
                  formatButtonShowsNext:
                      false, //Ngăn không cho Format Show trước
                  //Title Header Calendar Style
                  titleTextStyle: const TextStyle(
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
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(selectedDay, _selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      nextScreen(context, CheckinHistory(day: selectedDay));
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  setState(() {
                    _selectedMonth = focusedDay.month;
                  });
                },
                eventLoader: (day) {
                  for (final timeKeeping in widget.listTimeKeepingHistory) {
                    DateFormat format = DateFormat('dd/MM/yyyy');
                    if (isSameDay(day, format.parse(timeKeeping.day))) {
                      return [timeKeeping.state];
                    }
                  }
                  return [];
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty && events[0] != null) {
                      StateOFDay state = events[0] as StateOFDay;
                      return Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: state.color),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: StateOFDay.intime.color,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "ĐÚNG GIỜ",
                        style: TextStyle(
                            fontFamily: 'roboto',
                            fontSize: 12,
                            color: Color(0xFFDDC834),
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: StateOFDay.late.color,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "ĐI TRỄ",
                        style: TextStyle(
                            fontFamily: 'roboto',
                            fontSize: 12,
                            color: Color(0xFFDDC834),
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: StateOFDay.off.color,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "VẮNG",
                        style: TextStyle(
                            fontFamily: 'roboto',
                            fontSize: 12,
                            color: Color(0xFFDDC834),
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: MarginValue.medium, bottom: MarginValue.medium),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: Color(0xFF008ECF),
                      ),
                      label: Text(
                        "Tháng ${_selectedMonth == DateTime.now().month || _selectedMonth == null ? "này" : "$_selectedMonth"}",
                        style: const TextStyle(
                            color: Color(0xFF008ECF),
                            fontSize: 14,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF008ECF), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  nextScreen(
                                      context,
                                      CheckinHistory(
                                          day: DateFormat("dd/MM/yyyy").parse(
                                              widget
                                                  .listTimeKeepingHistory[index]
                                                  .day)));
                                },
                                child: TimeKeepingItem(
                                    timeKeeping:
                                        widget.listTimeKeepingHistory[index]));
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              thickness: 2,
                              color: Constants.lineColor,
                            );
                          },
                          itemCount: widget.listTimeKeepingHistory.length),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Constants.lineColor,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Thống kê chi tiết",
                      style: TextStyle(
                          color: Constants.textColor,
                          fontFamily: 'roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _statisticTable(hoursMonth: 120),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      drawer: AppBarWidget.buildDrawer(context),
    );
  }

  //create statistic table for one month
  Text _label(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Constants.textColor,
          fontFamily: 'roboto',
          fontSize: 12,
          fontWeight: FontWeight.w300),
    );
  }

  Text _infomation(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Constants.textColor,
          fontFamily: 'roboto',
          fontSize: 12,
          fontWeight: FontWeight.w600),
    );
  }

  Widget _attribute({required String title, required String content}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label(title),
        const SizedBox(
          height: 10,
        ),
        _infomation(content)
      ],
    );
  }

  TableRow _tableSpacer(double distance) {
    return TableRow(children: [
      SizedBox(
        height: distance,
      ),
      SizedBox(
        height: distance,
      )
    ]);
  }

  Widget _statisticTable(
      {required int hoursMonth,
      int? lateCount,
      int? offRequestCount,
      int? offNoRequestCount,
      int? goHomeEarlyCount}) {
    String hoursMonthStringFormat = "$hoursMonth giờ";
    String lateCountStringFormat =
        "${lateCount == null ? "0" : "$lateCount"} lần";
    String goHomeEarlyCountStringFormat =
        "${goHomeEarlyCount == null ? "0" : "$goHomeEarlyCount"} lần";
    String offRequestCountStringFormat =
        "${offRequestCount == null ? "0" : "$offRequestCount"} lần";
    String offNoRequestCountStringFormat =
        "${offNoRequestCount == null ? "0" : "$offNoRequestCount"} lần";
    return Table(
      children: [
        TableRow(children: [
          _attribute(title: "Số giờ làm", content: hoursMonthStringFormat),
          const SizedBox(),
        ]),
        _tableSpacer(10),
        TableRow(children: [
          _attribute(title: "Đi trễ", content: lateCountStringFormat),
          _attribute(title: "Về sớm", content: goHomeEarlyCountStringFormat)
        ]),
        _tableSpacer(10),
        TableRow(children: [
          _attribute(title: "Nghỉ làm", content: offRequestCountStringFormat),
          _attribute(
              title: "Nghỉ không phép", content: offNoRequestCountStringFormat)
        ])
      ],
    );
  }
}
