import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudgo_mobileapp/helper/helper_function.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/pages/information_page.dart';
import 'package:cloudgo_mobileapp/pages/request_page.dart';
import 'package:cloudgo_mobileapp/pages/test_notification.dart';
import 'package:cloudgo_mobileapp/pages/timekeeping_history_page.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:cloudgo_mobileapp/utils/database_service.dart';
import 'package:cloudgo_mobileapp/widgets/appbar_widget.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../object/User.dart';

// Hiển thị thông báo khi ẩn App
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

final monthList = List.generate(12, (index) => index + 1);
String token = "";
String employeeId = "";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeFirebaseApp();
  }

  Future<void> _initializeFirebaseApp() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      String? fcmToken = await messaging.getToken();

      await HelperFunctions.getTokenFromSF().then((value) {
        if (value != null) {
          token = value;
        }
      });
      await HelperFunctions.getEmployeeIdFromSF().then((value) {
        if (value != null) {
          employeeId = value;
        }
      });
      Map<String, dynamic> requestData = {
        "RequestAction": "SaveFcmToken",
        "token": fcmToken,
        "employeeId": employeeId
      };
      print('Token: $token');
      await saveFcmToken(token, requestData);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
      print('User granted permission: ${settings.authorizationStatus}');
      print('Firebase initialization successful!');
    } catch (e) {
      print('Firebase initialization failed: $e');
    }
  }

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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(
        titlebar: 'DASHBOARD',
        scaffoldKey: scaffoldKey,
        user: user,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
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
                      'GOOD MORNING, ${user?.name}',
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Constants.textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      'Một ngày làm việc vui vẻ nha !',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Constants.textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Ca hành chính (8:30 - 12:00, 13:30 - 17:30)',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.075,
                            child: ElevatedButton(
                              onPressed: () {
                                // getCheckLog(user!.token, user.id);
                                nextScreen(context, const TestNotification());
                                // nextScreen(context, const CheckGPS());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.select<CheckinRepository, bool>(
                                            (repository) =>
                                                repository.isTodayCheckIn)
                                        ? Constants.dangerousColor
                                        : Constants.successfulColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                context.select<CheckinRepository, bool>(
                                        (repository) =>
                                            repository.isTodayCheckIn)
                                    ? "Ra ca"
                                    : "Vào ca",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      indent: 10,
                      endIndent: 10,
                      color: Constants.lineColor,
                    ),
                    const SizedBox(
                      height: MarginValue.small,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: width * 1 / 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Tiện ích",
                            style: TextStyle(
                              color: Constants.textColor,
                              fontSize: FontSize.medium,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: MarginValue.small,
                          ),
                          Wrap(
                            spacing: width * 1 / 16.0,
                            runSpacing: 20.0,
                            children: [
                              buttonItem(
                                  const Icon(
                                    Icons.notes_outlined,
                                    color: Color(0xFFD9D9D9),
                                    size: 32,
                                  ),
                                  "Đơn báo",
                                  "Xin nghỉ phép",
                                  width,
                                  height,
                                  () =>
                                      nextScreen(context, const RequestPage())),
                              buttonItem(
                                  const Icon(
                                    Icons.content_paste_search_outlined,
                                    color: Color(0xFFFFA600),
                                    size: 32,
                                  ),
                                  "Chi tiết công",
                                  "Lịch sử chấm công",
                                  width,
                                  height,
                                  () => nextScreen(
                                      context, const TimekeepingHistoryPage())),
                              buttonItem(
                                  const Icon(
                                    Icons.list_alt_outlined,
                                    color: Color(0xFFEC3939),
                                    size: 32,
                                  ),
                                  "Báo cáo",
                                  "Thống kê chấm công",
                                  width,
                                  height,
                                  null),
                              buttonItem(
                                  const Icon(
                                    Icons.account_circle_outlined,
                                    color: Color(0xFF1B74E4),
                                    size: 32,
                                  ),
                                  "Cá nhân",
                                  "Thông tin cá nhân",
                                  width,
                                  height,
                                  () => nextScreen(
                                      context, const InformationPage())),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: AppBarWidget.buildDrawer(context),
    );
  }

  Column data(Icon icon, String label, String smallLabel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        Expanded(child: Container()),
        Text(
          label,
          style: const TextStyle(
              color: Constants.textColor,
              fontSize: FontSize.medium,
              fontFamily: 'roboto',
              fontWeight: FontWeight.w700),
        ),
        Text(
          smallLabel,
          style: const TextStyle(
              color: Constants.textColor,
              fontSize: FontSize.small,
              fontFamily: 'roboto',
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis),
          maxLines: 1,
        )
      ],
    );
  }

  Widget buttonItem(Icon icon, String label, String smallLabel,
      double screenWidth, double screenHeight,
      [void Function()? callBack, bool isVisible = true]) {
    return Visibility(
      visible: isVisible,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
            elevation: 8.0,
            backgroundColor: Constants.primaryColor,
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        child: Container(
            width: 0.3 * screenWidth,
            height: screenWidth * 0.22,
            margin: const EdgeInsets.only(
                left: MarginValue.small,
                top: MarginValue.medium,
                bottom: MarginValue.small),
            child: data(icon, label, smallLabel)),
      ),
    );
  }
}
