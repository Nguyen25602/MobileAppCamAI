// ignore: file_names
import 'package:cloudgo_mobileapp/object/Notification.dart';
import 'package:flutter/material.dart' as mt;

class NotificationRepository with mt.ChangeNotifier {
  late String _token;
  late String _employeeId;
  int _unreadNotification = 0;
  List<Notification> notifictions = [];

  NotificationRepository._create();
  static NotificationRepository create() {
    return NotificationRepository._create();
  }

  int get unreadNotify => _unreadNotification;

  void setUnreadNotify(int newValue) {
    _unreadNotification = newValue;
    notifyListeners();
  }

  void clear() {
    notifictions.clear();
    _unreadNotification = 0;
  }

  Future<Map<String, dynamic>> _fectchData() async {
    return Future.delayed(
      Duration(seconds: 2),
      () => dataExample,
    );
  }

  Future<List<Notification>> getData() async {
    Map<String, dynamic> data;
    try {
      data = await _fectchData();
    } on Exception {
      data = {
        "success": '0',
        "entry_list": [],
        "unread_count": "0",
      };
    }
    List<Notification> res = [];
    _unreadNotification = int.parse(data["unread_count"]);
    for (final entry in data["entry_list"]) {
      if (entry["data"]["extra_data"]["action"] ==
          "employee_checkin_mobileapp") {
        res.add(NotificationCheckin.fromMap(entry));
      } else {
        if (entry["data"]["extra_data"].containsKey("status")) {
          res.add(NotificationApproveLeaving.fromMap(entry));
        } else {
          res.add(NotificationLeaving.fromMap(entry));
        }
      }
    }
    return res;
  }

  Future updateUserInformation(String token, String employeeId) async {
    _token = token;
    _employeeId = employeeId;
    notifictions = await getData();
  }

  Future getNewData() async {
    notifictions = await getData();
    notifyListeners();
  }

  List<Notification> getListNotificationCheckin() {
    return notifictions.whereType<NotificationCheckin>().toList();
  }

  List<Notification> getListNotificationLeaving() {
    return notifictions.whereType<NotificationLeaving>().toList();
  }

  List<Notification> getListNotificationApproveLeaving() {
    return notifictions.whereType<NotificationApproveLeaving>().toList();
  }
}
