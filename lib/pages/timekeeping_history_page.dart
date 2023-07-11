import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
class TimekeepingHistoryPage extends StatefulWidget {
  const TimekeepingHistoryPage({super.key});
  
  @override
  State<TimekeepingHistoryPage> createState() => _TimekeepingHistoryPageState();
}

class _TimekeepingHistoryPageState extends State<TimekeepingHistoryPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    // TODO: implement initState
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
          color:  Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 5,),
              TableCalendar(
                focusedDay: _focusedDay, 
                firstDay: DateTime(2023,1,1), 
                lastDay: DateTime(2023,12,30),
                calendarFormat: _format,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: false,
                calendarStyle:CalendarStyle(
                  markersMaxCount: 1,
                  todayDecoration:const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  // Style Ngày chọn //
                  selectedDecoration:const  BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  // Style Các Ngày Thường //
                  defaultDecoration:const  BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  // Style Các ngày t7 CN //
                  weekendDecoration:const  BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  // Style Các ngày Lễ //
                  holidayDecoration:const  BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  // Style ngày ngoài tháng
                  outsideDecoration:const  BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle:const TextStyle(
                    color: Color.fromARGB(255, 147, 181, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),       
                  defaultTextStyle: TextStyle(
                    color: Constants.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),           
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle:
                  TextStyle(color: Constants.textColor
                  )
                ),
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
                eventLoader: (day) {
                  return [1,2,3];
                },
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
                  const IconWidgets(
                    iconPath: FontAwesomeIcons.house,
                    text: "Home",
                  ),
                  IconWidgets(
                    iconPath: FontAwesomeIcons.mapLocation,
                    text: "GPS Check",
                    onPressed: () {
                      nextScreen(context, const CheckGPS());
                    },
                  ),
                  IconWidgets(
                    iconPath: FontAwesomeIcons.fileAlt,
                    text: "Log Check",
                    onPressed: () {},
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