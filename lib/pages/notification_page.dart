import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/widgets/notification_item.dart';
import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:cloudgo_mobileapp/object/CheckIn.dart';
class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  final List<StaffNotification> staffNotifications = [
    CheckInNotification(checkIn: CheckIn(date: DateTime.now(), device: TypeDevice.camera)),
    RequestNotification(request: Request(name: "Trần Thiên Tường", start: DateTime(2023,7,15), end: DateTime(2023,7,25), type: TimeOffType.workFromHome, reason: "Ốm", state: StateOFRequest.accept)),
    RequestNotification(request: Request(name: "Trần Thiên Tường", start: DateTime(2023,7,15), end: DateTime(2023,7,25), type: TimeOffType.workFromHome, reason: "Ốm", state: StateOFRequest.reject)),
    CheckInNotification(checkIn: CheckIn(date: DateTime.now(), device: TypeDevice.gps),),
    CheckInNotification(checkIn: CheckIn(date: DateTime.now(), device: TypeDevice.wifi)),
  ];
  final List<ManagerNotification> managerNotifications = [];

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late TabController _controller;
  List<Widget> listNotification = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    for(final notification in widget.staffNotifications) {
      listNotification.add(notification.build());
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:const Text("THÔNG BÁO",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.36
          ),),
        bottom:  PreferredSize(
          preferredSize:const Size.fromHeight(25.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:MarginValue.small, vertical: MarginValue.small),
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.red,
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),

              controller: _controller,
              tabs: [
                label(Icons.checklist_outlined,2,),
                label(Icons.how_to_reg, 2,),
                label(Icons.note_add,2,)
              ]
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Container(
            child: ListView(
              padding: EdgeInsets.only(top: MarginValue.small, bottom: MarginValue.small),
              children: ListTile.divideTiles(
                color: Colors.red,
                context: context,
                tiles: listNotification).toList(),
            ),
          ),
          Container(),
          Container()
        ]),
    );
  }

  Widget label(IconData data, int notificationSize) {
    return Row(
      children: [
        Icon(data, color: Colors.black,),
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5)),
          width: 20,
          height: 20,
          child: Center(
            child: Text(
              '$notificationSize',
              style:const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        )
      ],
    );
  }
}