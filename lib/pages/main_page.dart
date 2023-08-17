import 'package:cloudgo_mobileapp/helper/helper_function.dart';
import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/pages/home_page.dart';
import 'package:cloudgo_mobileapp/pages/notification_page.dart';
import 'package:cloudgo_mobileapp/pages/request_page.dart';
import 'package:cloudgo_mobileapp/pages/test.dart';
import 'package:cloudgo_mobileapp/pages/timekeeping_history_page.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';

Future updateRepository(
    BuildContext context, String token, String name, String employeeId) async {
  await context
      .read<CheckinRepository>()
      .updateUserInformation(token, employeeId);
  await context
      .read<RequestRepository>()
      .updateUserInformation(token, name, employeeId);
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String token = "";
  String employeeId = "";
  Map<String, dynamic> data = {};
  final items = const [
    Icons.house_outlined,
    Icons.edit_calendar_outlined,
    Icons.content_paste_search_outlined,
    Icons.notifications_active_outlined,
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
    const CheckInWifi(),
  ];
  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
      }
    });
    if (data.isNotEmpty) {
      // ignore: use_build_context_synchronously
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
                    await context.read<CheckinRepository>().checkIn(data);
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
                        final wifiName =
                            await info.getWifiName(); // "FooNetwork"
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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
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
        });
  }
}
