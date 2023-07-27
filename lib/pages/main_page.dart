import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudgo_mobileapp/pages/checkgps_page.dart';
import 'package:cloudgo_mobileapp/pages/home_page.dart';
import 'package:cloudgo_mobileapp/pages/notification_page.dart';
import 'package:cloudgo_mobileapp/pages/request_page.dart';
import 'package:cloudgo_mobileapp/pages/test.dart';
import 'package:cloudgo_mobileapp/pages/timekeeping_history_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
    final items =const [
    Icons.house_outlined,
    Icons.photo_filter,
    Icons.content_paste_search_outlined,
    Icons.notifications_active_outlined,
  ];
    final pages = [
      const HomeScreen(),
      const RequestPage(),
      TimekeepingHistoryPage(),
      NotificationPage(),
      const CheckGPS(),
      const CheckWiFi(),
    ];
  int _bottomIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomIndex,
        children: pages,),
      floatingActionButton: SpeedDial(
        icon:Icons.location_on_outlined,
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
            child: const Icon(Icons.gps_fixed_outlined, color: Constants.primaryColor,),
            onTap: () {
              setState(() {
                _bottomIndex = 4;
              });
            },
          ),
          SpeedDialChild(
            backgroundColor: Constants.enableButton,
            child: const Icon(Icons.wifi, color: Constants.primaryColor,),
            onTap: () {
              setState(() {
                _bottomIndex = 5;
              });
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: items.length,
        activeIndex: _bottomIndex,
        onTap: (index) { setState(() {
          _bottomIndex = index;
        });},
        tabBuilder: (index, isActive) {
          Color activeColor = isActive ? Constants.enableButton : Constants.textColor;  
          return Icon(items[index], size: 30,color:  activeColor,);
        },
        
        gapLocation: GapLocation.center,
      )
    );
  }
}