// ignore: file_names
import 'package:cloudgo_mobileapp/object/Notification.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:flutter/material.dart' as mt;

int notificationTemp = 0;

class NotificationRepository with mt.ChangeNotifier {
  late String _token;
  late String _employeeId;
  int _unreadNotification = 0;
  //
  //
  int? _nextOffSet = 0;
  List<Notification> notifictions = [];

  NotificationRepository._create();
  static NotificationRepository create() {
    return NotificationRepository._create();
  }

  int get unreadNotify => _unreadNotification;
  int? get nextOffSet => _nextOffSet;
  void setUnreadNotify(int newValue) {
    _unreadNotification = newValue;
    notificationTemp = _unreadNotification;
    //func
    notifyListeners();
  }

  //Clear all notification
  void clear() {
    notifictions.clear();
    _unreadNotification = 0;
    notificationTemp = 0;
    _nextOffSet = 0;
  }

  //call to add new notfication when you scroll down
  Future onSCrollDown() async {
    notifictions.addAll(await getData());
    if (_nextOffSet == null) {
      _unreadNotification =
          notifictions.where((element) => !element.isRead).length;
      notificationTemp = _unreadNotification;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> _fectchData() async {
    return getNotificationList(_token, _employeeId, _nextOffSet);
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
        "paging": {"next_offset": ""}
      };
    }
    List<Notification> res = [];

    _nextOffSet = data["paging"]["next_offset"] == ""
        ? null
        : int.parse(data["paging"]["next_offset"]);

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

    if (_nextOffSet != null) {
      _unreadNotification = int.parse(data["unread_count"]);
      notificationTemp = _unreadNotification;
    }

    return res;
  }

  void updateNotification(Notification newNotification) {
    notifictions.insert(0, newNotification);
    _unreadNotification++;
    notificationTemp = _unreadNotification;
    notifyListeners();
  }

  Future readNotification(int id) async {
    _unreadNotification--;
    notificationTemp = _unreadNotification;
    notifyListeners();
    return await markNotificationsAsRead(_token, _employeeId, id);
  }

  Future updateUserInformation(String token, String employeeId) async {
    _token = token;
    _employeeId = employeeId;
    notifictions = await getData();
    if (_nextOffSet == null) {
      _unreadNotification =
          notifictions.where((element) => !element.isRead).length;
      notificationTemp = _unreadNotification;
    }
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
