// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:cloudgo_mobileapp/helper/helper_function.dart';
import 'package:cloudgo_mobileapp/main.dart';
import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/pages/home_page.dart';
import 'package:cloudgo_mobileapp/pages/notification_page.dart';
import 'package:cloudgo_mobileapp/pages/request_page.dart';
import 'package:cloudgo_mobileapp/pages/timekeeping_history_page.dart';
import 'package:cloudgo_mobileapp/pages/welcome_page.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/repository/NotificationRepository.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:cloudgo_mobileapp/object/Notification.dart' as ntf;

// Hiển thị thông báo khi ẩn App

Future updateRepository(
    BuildContext context, String token, String name, String employeeId) async {
  await context
      .read<CheckinRepository>()
      .updateUserInformation(token, employeeId);
  await context
      .read<RequestRepository>()
      .updateUserInformation(token, name, employeeId);
  await context
      .read<NotificationRepository>()
      .updateUserInformation(token, employeeId);
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    _initializeFirebaseApp();
  }

  // Hiển thị thông báo khi ẩn App
  Future<void> showNotificationToast(RemoteMessage message) async {
    String notificationTitle = message.notification?.title ?? "Notification";
    String notificationBody = message.notification?.body ?? "Empty body";
    print("Handling a background message: Đây n");

    Fluttertoast.showToast(
      msg: "$notificationTitle: $notificationBody",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
    );
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
        showNotificationToast(message);
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        Map<String, dynamic> extraData = jsonDecode(message.data['extra_data']);
        Future.microtask(() {
          if (extraData["action"] == "employee_checkin_mobileapp") {
            context.read<NotificationRepository>().updateNotification(
                ntf.NotificationCheckin(
                    message.data["raw_message"],
                    DateFormat("yyyy-MM-dd HH:mm:ss")
                        .parse(extraData["checkin_time"]),
                    false,
                    int.parse(message.data["id"]),
                    extraData));
          } else {
            if (extraData.containsKey("status")) {
              context.read<NotificationRepository>().updateNotification(
                  ntf.NotificationApproveLeaving(
                      message.data["raw_message"],
                      DateFormat("yyyy-MM-dd HH:mm:ss").parse(extraData[
                          "created_time"]), // Fix Hoang Nguyen 21/08/2023
                      StateOFRequest.fromString(extraData["created_time"]),
                      false,
                      int.parse(message.data["id"]),
                      extraData));
              context.read<RequestRepository>().updateWhenHaveNotification();
            } else {
              context.read<NotificationRepository>().updateNotification(
                  ntf.NotificationLeaving(
                      message.data["raw_message"],
                      DateFormat("yyyy-MM-dd HH:mm:ss")
                          .parse(extraData["created_time"]),
                      false,
                      int.parse(message.data["id"]),
                      extraData));
            }
          }
        });

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

  String token = "";
  String employeeId = "";
  Map<String, dynamic> data = {};
  final items = const [
    Icons.house_outlined,
    Icons.edit_calendar_outlined,
    Icons.content_paste_search_outlined,
    Icons.notifications_none,
  ];
  final itemsText = const [
    "Trang chủ",
    "Nghỉ phép",
    "LS chấm công",
    "Thông báo",
  ];
  final pages = [
    const HomeScreen(),
    const RequestPage(),
    const TimekeepingHistoryPage(),
    NotificationPage(),
    const CheckGPS(),
  ];
  int _bottomIndex = 0;

  Future<void> getUserLoggedInStatus() async {
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
    await checkToken(token, employeeId).then((value) {
      if (value != null) {
        if (value['success'] == "1") {
          data = value;
        }
        //
      }
    });
    if (data.isNotEmpty) {
      await updateRepository(context, data['token'],
          data['user_info']['full_name'], data['user_info']['id']);
    }
  }

  // show dialog checkin wifi
  Future<void> dialogBuilder(
      BuildContext context, String wifiname, String ip, String bssid) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Tên wifi:'),
                        SizedBox(height: 20),
                        Text('IP:'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(wifiname),
                        const SizedBox(height: 20),
                        Text(ip),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    final checkin =
                        CheckIn(date: DateTime.now(), device: TypeDevice.wifi);
                    final data = checkin.toMap();
                    data["bssid"] = bssid;
                    String res =
                        await context.read<CheckinRepository>().checkIn(data);
                    await checkinStatusDialog(context, res, "WIFI");
                  },
                  child: const Text('Check - In'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final repository = Provider.of<NotificationRepository>(context);
    if (isSigned == true) {
      return FutureBuilder(
          future: getUserLoggedInStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (data.isEmpty) {
              HelperFunctions.saveUserLoggedInStatus(false);
              HelperFunctions.saveAccessTokenSF("");
              HelperFunctions.saveUserNameSF("");
              HelperFunctions.saveEmployeeIdSF("");
              context.read<UserProvider>().clear();
              context.read<RequestRepository>().clear();
              context.read<CheckinRepository>().clear();
              context.read<NotificationRepository>().clear();
              isSigned = false;
              // Logic Logout
              return const WelcomePage();
            } else {
              final userProvider = Provider.of<UserProvider>(context);
              User user = User.fromMap(data);
              userProvider.updateUserStart(user);

              return StatefulBuilder(builder: (context, setState) {
                return Scaffold(
                    body: IndexedStack(
                      index: _bottomIndex,
                      children: pages,
                    ),
                    floatingActionButton: SpeedDial(
                      icon: Icons.location_on_outlined,
                      activeIcon: Icons.close,
                      spacing: 3,
                      childPadding: const EdgeInsets.all(5),
                      spaceBetweenChildren: 4,
                      elevation: 8.0,
                      animationCurve: Curves.elasticInOut,
                      isOpenOnStart: false,
                      children: [
                        //button checkin GPS
                        SpeedDialChild(
                          backgroundColor: Constants.enableButton,
                          child: const Icon(
                            Icons.gps_fixed_outlined,
                            color: Constants.primaryColor,
                          ),
                          onTap: () {
                            // Fix By Hoang Nguyen 20/8/2023
                            nextScreen(context, CheckGPS());
                          },
                        ),
                        //button checkin wifi
                        SpeedDialChild(
                          backgroundColor: Constants.enableButton,
                          child: const Icon(
                            Icons.wifi,
                            color: Constants.primaryColor,
                          ),
                          onTap: () async {
                            final info = NetworkInfo();
                            final wifiName =
                                await info.getWifiName(); // "FooNetwork"
                            final wifiBSSID =
                                await info.getWifiBSSID(); // 11:22:33:44:55:66
                            final wifiIP = await info.getWifiIP();
                            await dialogBuilder(
                                context,
                                wifiName ?? "Not found",
                                wifiIP ?? "0.0.0.0",
                                wifiBSSID ?? "0:0:0:0:0:0");
                          },
                        ),
                      ],
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                      borderColor: Colors.black,
                      itemCount: items.length,
                      activeIndex: _bottomIndex,
                      onTap: (index) {
                        setState(() {
                          _bottomIndex = index;
                        });
                      },
                      tabBuilder: (index, isActive) {
                        Color activeColor = isActive
                            ? Constants.enableButton
                            : Constants.textColor;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            index == 3
                                ? Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Icon(
                                        items[index],
                                        size: 30,
                                        color: activeColor,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red, // Màu nền
                                          ),
                                          child: Text(
                                            notificationTemp
                                                .toString(), // Số lượng thông báo
                                            style: const TextStyle(
                                              color: Colors.white, // Màu chữ
                                              fontSize: FontSize.verySmallxxx,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Icon(
                                    items[index],
                                    size: 30,
                                    color: activeColor,
                                  ),
                            Text(
                              itemsText[index],
                              style: TextStyle(
                                color: activeColor,
                                fontSize: FontSize.verySmall,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        );
                      },
                      gapLocation: GapLocation.center,
                    ));
              });
            }
          });
    } else {
      return Scaffold(
          body: IndexedStack(
            index: _bottomIndex,
            children: pages,
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.location_on_outlined,
            activeIcon: Icons.close,
            spacing: 3,
            childPadding: EdgeInsets.all(5),
            spaceBetweenChildren: 4,
            elevation: 8.0,
            animationCurve: Curves.elasticInOut,
            isOpenOnStart: false,
            children: [
              SpeedDialChild(
                backgroundColor: Constants.enableButton,
                child: const Icon(
                  Icons.gps_fixed_outlined,
                  color: Constants.primaryColor,
                ),
                onTap: () {
                  setState(() {
                    _bottomIndex = 4;
                  });
                },
              ),
              SpeedDialChild(
                backgroundColor: Constants.enableButton,
                child: const Icon(
                  Icons.wifi,
                  color: Constants.primaryColor,
                ),
                onTap: () async {
                  final info = NetworkInfo();
                  final wifiName = await info.getWifiName(); // "FooNetwork"
                  final wifiBSSID =
                      await info.getWifiBSSID(); // 11:22:33:44:55:66
                  final wifiIP = await info.getWifiIP();
                  await dialogBuilder(context, wifiName ?? "Not found",
                      wifiIP ?? "0.0.0.0", wifiBSSID ?? "0:0:0:0:0:0");
                },
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            borderColor: Colors.black,
            itemCount: items.length,
            activeIndex: _bottomIndex,
            onTap: (index) {
              setState(() {
                _bottomIndex = index;
              });
            },
            tabBuilder: (index, isActive) {
              Color activeColor =
                  isActive ? Constants.enableButton : Constants.textColor;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  index == 3
                      ? Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Icon(
                              items[index],
                              size: 30,
                              color: activeColor,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red, // Màu nền
                                ),
                                child: Text(
                                  notificationTemp
                                      .toString(), // Số lượng thông báo
                                  style: const TextStyle(
                                    color: Colors.white, // Màu chữ
                                    fontSize: FontSize.verySmallxxx,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Icon(
                          items[index],
                          size: 30,
                          color: activeColor,
                        ),
                  Text(
                    itemsText[index],
                    style: TextStyle(
                      color: activeColor,
                      fontSize: FontSize.verySmall,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              );
            },
            gapLocation: GapLocation.center,
          ));
    }
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
