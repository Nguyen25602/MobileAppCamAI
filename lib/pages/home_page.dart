import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/pages/test1.dart';
import 'package:cloudgo_mobileapp/pages/timekeeping_history_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/database_service.dart';
import 'package:cloudgo_mobileapp/widgets/appbar_widget.dart';
import 'package:cloudgo_mobileapp/widgets/calendar_widget.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final monthList = List.generate(12, (index) => index + 1);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedMonth = DateTime.now().month;
  final DatabaseService databaseService = DatabaseService();
  QuerySnapshot? querySnapshot;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isExpanded = false;
  bool isChanged = false;
  bool flag = false;

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  @override
  void initState() {
    super.initState();
    getDate();
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

        // ignore: avoid_print
        print('Ngày: $date');
        // ignore: avoid_print
        print('Check-in: $checkIn');
        // ignore: avoid_print
        print('Check-out: $checkOut');
      }
    }).catchError((error) {
      // ignore: avoid_print
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
                          color: Constants.textColor,
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
                          color: Constants.textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    CalendarWidget(
                      selectedMonth: selectedMonth,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.analytics_sharp, size: 20),
                            label: Text('Thống kê chấm công',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Constants.textColor,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold)),
                            onPressed: null,
                          ),
                          TextButton.icon(
                            icon: const Icon(
                              Icons.list,
                              size: 20,
                              color: Color(0xff9DB6F8),
                            ),
                            label: Text(
                                'Tháng ${selectedMonth == DateTime.now().month ? 'này' : selectedMonth}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff9DB6F8),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 250,
                                    padding: EdgeInsets.all(MarginValue.small),
                                    child: ListView.builder(
                                      itemCount: monthList.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title:
                                              Text('tháng ${monthList[index]}'),
                                          onTap: () {
                                            setState(() {
                                              //request data
                                              selectedMonth = monthList[index];
                                              Navigator.pop(context);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                onPressed: null,
                                disabledColor: Constants.successfulColor,
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                                shape: const CircleBorder(),
                                child: Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Constants.whiteTextColor,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Số ngày làm trong tháng: 20",
                                    style: TextStyle(
                                        fontFamily: "roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Constants.textColor),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Đạt KPI",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Constants.textColor),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Constants.textColor,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                onPressed: null,
                                disabledColor: Constants.warningColor,
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                                shape: const CircleBorder(),
                                child: Icon(
                                  Icons.sentiment_dissatisfied,
                                  size: 20,
                                  color: Constants.whiteTextColor,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Số ngày trễ trong tháng: 2",
                                    style: TextStyle(
                                        fontFamily: "roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Constants.textColor),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Đạt Yêu Cầu",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Constants.textColor),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Constants.textColor,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                onPressed: null,
                                disabledColor: Constants.dangerousColor,
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                                shape: const CircleBorder(),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Constants.whiteTextColor,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Số ngày nghĩ trong tháng: 1",
                                    style: TextStyle(
                                        fontFamily: "roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Constants.textColor),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Đạt Yêu Cầu",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Constants.textColor),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Constants.textColor,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    // ignore: deprecated_member_use
                    iconPath: FontAwesomeIcons.fileAlt,
                    text: "Log Check",
                    onPressed: () {
                      nextScreenReplace(context, TimekeepingHistoryPage());
                    },
                  ),
                  IconWidgets(
                    iconPath: FontAwesomeIcons.wifi,
                    text: "Check Wi-Fi",
                    onPressed: () {
                      nextScreen(context, const Test1());
                    },
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
