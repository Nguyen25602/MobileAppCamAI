import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/pages/event.dart';
import 'package:cloudgo_mobileapp/pages/login_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/database_service.dart';
import 'package:cloudgo_mobileapp/widgets/appbar_widget.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService databaseService = DatabaseService();
  QuerySnapshot? querySnapshot;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isExpanded = false;
  bool isChanged = false;
  bool flag = false;
  int _hellocuccung(DateTime date) {
    final events = selectedEvents[date];
    if (events != null && events.isNotEmpty) {
      return events[0].checkInOutData['status'];
    }
    return 0; // Mặc định là status = 0
  }

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
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
  void initState() {
    super.initState();
    getDate();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void getDate() async {
    try {
      QuerySnapshot? snapshot = await databaseService.getDateTime();
      setState(() {
        querySnapshot = snapshot;
      });
    } catch (e) {
      showSnackbar(context, Colors.red, 'Lỗi khi lấy dữ liệu từ Firestore: $e');
    }
  }

  void getDataFromFirestore() {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('checkInOutData');

    collectionRef.get().then((QuerySnapshot querySnapshot) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (int i = 0; i < documents.length; i++) {
        DocumentSnapshot documentSnapshot = documents[i];
        String date = documentSnapshot.id;
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String checkIn = data['checkIn'];
        String checkOut = data['checkOut'];

        print('Ngày: $date');
        print('Check-in: $checkIn');
        print('Check-out: $checkOut');
      }
    }).catchError((error) {
      print('Lỗi khi lấy dữ liệu từ Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(
        titlebar: 'DASHBOARD',
        scaffoldKey: scaffoldKey,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'GOOD MORNING, NGUYÊN!',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Constants().textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Một ngày làm việc vui vẻ nha !',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Constants().textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    SizedBox(
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
                            print(selectedDay);
                            focusedDay = focusDay;
                          });
                        },
                        // Style màu sắc + chữ trong Calendar //
                        calendarStyle: CalendarStyle(
                          markersAlignment: Alignment.bottomCenter,
                          markersMaxCount: 4,
                          rangeEndTextStyle:
                              const TextStyle(color: Colors.blue),
                          // Style Text Khi Chọn //
                          selectedTextStyle: TextStyle(
                              color: Constants().whiteTextColor, fontSize: 14),
                          // Style Text Khi Chọn //
                          // Hiển Thị Today //
                          isTodayHighlighted: true,
                          todayTextStyle: TextStyle(
                              color: Constants().whiteTextColor, fontSize: 14),
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
                          // Style Các Ngày Thường //
                          defaultDecoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // Style Các ngày t7 CN //
                          weekendDecoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // Style Các ngày Lễ //
                          holidayDecoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // Style ngày ngoài tháng
                          outsideDecoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          withinRangeDecoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          rangeStartDecoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          rangeEndDecoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          rangeHighlightColor:
                              const Color.fromARGB(255, 74, 255, 33),
                          // Style Text Ngày cuối tuần //
                          weekendTextStyle: TextStyle(
                              color: Constants().warningColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          // Style Text Ngày Lễ //
                          defaultTextStyle: TextStyle(
                              color: Constants().textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle:
                                TextStyle(color: Constants().textColor)),
                        headerStyle: HeaderStyle(
                          leftChevronIcon: FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            color: Constants().textColor,
                            size: 14,
                          ),
                          rightChevronIcon: FaIcon(
                            FontAwesomeIcons.chevronRight,
                            color: Constants().textColor,
                            size: 14,
                          ),
                          // Button Format
                          titleCentered: true, // Text Date nằm giữa
                          formatButtonShowsNext:
                              false, //Ngăn không cho Format Show trước
                          //Title Header Calendar Style
                          titleTextStyle: TextStyle(
                              color: Constants().textColor,
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.5),
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
                    ),
                  ],
                ),
              ),
              ..._getEventsfromDay(selectedDay).map(
                (Event event) => ListTile(
                  title: Text(
                    event.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
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
                color: Constants().lineColor, // Màu sắc của đường thẳng
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
                    onPressed: () {
                      nextScreenReplace(context, const LoginPage());
                    },
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

void demo() {}
