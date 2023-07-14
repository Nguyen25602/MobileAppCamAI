import 'package:cloudgo_mobileapp/pages/home_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/timekeeping_item.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/object/timekeeping.dart';
import 'package:intl/intl.dart';

class TimekeepingHistoryPage extends StatefulWidget {
  TimekeepingHistoryPage({super.key});
  final listTimeKeepingHistory = [
    TimeKeeping(
        checkIn: DateTime.now(),
        checkOut: DateTime.now(),
        typeCheckIn: TypeDevice.gps),
    TimeKeeping(
        checkIn: DateTime.now().subtract(const Duration(days: 1)),
        checkOut: DateTime.now().subtract(const Duration(days: 1)),
        typeCheckIn: TypeDevice.camera),
    TimeKeeping(
        checkIn: DateTime.now().subtract(const Duration(days: 3)),
        checkOut: DateTime.now().subtract(const Duration(days: 3)),
        typeCheckIn: TypeDevice.wifi),
    TimeKeeping(
        checkIn: DateTime.now().subtract(const Duration(days: 5)),
        checkOut: DateTime.now().subtract(const Duration(days: 5)),
        typeCheckIn: TypeDevice.camera),
    TimeKeeping(
        checkIn: DateTime.now().subtract(const Duration(days: 2)),
        checkOut: DateTime.now().subtract(const Duration(days: 2)),
        typeCheckIn: TypeDevice.gps),
  ];
  @override
  State<TimekeepingHistoryPage> createState() => _TimekeepingHistoryPageState();
}

class _TimekeepingHistoryPageState extends State<TimekeepingHistoryPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(
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
                calendarStyle: CalendarStyle(
                  markersMaxCount: 1,
                  rangeEndTextStyle: const TextStyle(color: Colors.blue),
                  // Style Ngày chọn //
                  selectedTextStyle:
                      TextStyle(color: Constants.whiteTextColor, fontSize: 14),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  //Style ngày hôm nay
                  todayTextStyle:
                      TextStyle(color: Constants.whiteTextColor, fontSize: 14),
                  todayDecoration: const BoxDecoration(
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
                  formatButtonVisible: false,
                  formatButtonShowsNext:
                      false, //Ngăn không cho Format Show trước
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
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(selectedDay, _selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
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
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 5,
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
                        width: 10,
                        height: 19,
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
                        width: 10,
                        height: 10,
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
                        width: 10,
                        height: 10,
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
                padding: EdgeInsets.only(left: MarginValue.medium),
                alignment: Alignment.topLeft,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          color: Constants.enableButton,
                          size: 20,
                        ),
                        label: Text(
                          "Tháng 9",
                          style: TextStyle(
                              color: Constants.enableButton,
                              fontSize: 12,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Constants.enableButton, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return TimeKeepingItem(
                                  timeKeeping:
                                      widget.listTimeKeepingHistory[index]);
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                thickness: 2,
                                color: Constants.lineColor,
                              );
                            },
                            itemCount: widget.listTimeKeepingHistory.length),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: SizedBox(
          height: 62,
          child: Column(
            children: [
              Container(
                height: 3, // Chiều cao của đường thẳng
                width: double.infinity, // Đặt độ rộng thành vô hạn
                color: Constants.lineColor, // Màu sắc của đường thẳng
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconWidgets(
                    iconPath: FontAwesomeIcons.house,
                    text: "Home",
                    onPressed: () {
                      nextScreen(context, const HomeScreen());
                    },
                  ),
                  IconWidgets(
                    iconPath: FontAwesomeIcons.mapLocation,
                    text: "GPS Check",
                    onPressed: () {
                      nextScreen(context, const CheckGPS());
                    },
                  ),
                  const IconWidgets(
                    // ignore: deprecated_member_use
                    iconPath: FontAwesomeIcons.fileAlt,
                    text: "Log Check",
                    onPressed: null,
                  ),
                  IconWidgets(
                    iconPath: FontAwesomeIcons.wifi,
                    text: "Check Wi-Fi",
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: AppBarWidget.buildDrawer(context),
    );
  }
}
