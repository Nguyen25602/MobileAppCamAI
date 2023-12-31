import 'dart:io';

import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CheckinRepository with ChangeNotifier {
  late String _token;
  late String _employeeId;
  bool isTodayCheckIn = false;
  String checkinTime = "";
  String checkoutTime = "";
  List<CheckIn> listData = [];
  CheckinRepository._create();
  static CheckinRepository create() {
    CheckinRepository repository = CheckinRepository._create();
    return repository;
  }

  String get token => _token;

  void clear() {
    listData.clear();
    checkinTime = "";
    checkoutTime = "";
  }

  Future updateUserInformation(String token, String employeeId) async {
    _token = token;
    _employeeId = employeeId;
    listData = await getData();
    isTodayCheckIn = isCheckin();
    checkinTime = timeCheckIn();
    checkoutTime = timeCheckOut();
  }

//this will be replaced by the function call get data
  Future<Map<String, dynamic>> _fetchData() {
    return getCheckLog(_token, _employeeId);
  }

  CheckIn _convertToCheckin(Map<String, dynamic> item) {
    return CheckIn.fromMap(item);
  }

  Future<List<CheckIn>> getData() async {
    Map<String, dynamic> data;
    try {
      data = await _fetchData();
    } on Exception {
      data = {"success": '0', "data": []};
    }

    List<CheckIn> res = [];
    if ((data['data'] as List).isNotEmpty) {
      for (var item in data['data']) {
        res.add(_convertToCheckin(item));
      }
    }
    return res;
  }

  List<CheckIn> filterByDay(DateTime day) {
    return listData
        .where((element) => isSameDay(element.dateTime, day))
        .toList();
  }

  List<DateTime> getValidateDay() {
    var listDayCheckin = listData
        .map((checkin) =>
            "${checkin.dateTime.year}-${checkin.dateTime.month}-${checkin.dateTime.day}")
        .toSet();

    return listDayCheckin.map((e) => DateFormat("yy-M-D").parse(e)).toList();
  }

  Future<String> checkIn(Map<String, dynamic> data) async {
    data["RequestAction"] = "AddCheckLog";
    data["token"] = _token;
    data["employeeId"] = _employeeId;
    final result = await addCheckLog(_token, data);
    await getNewData();
    isTodayCheckIn = isCheckin();
    checkinTime = timeCheckIn();
    checkoutTime = timeCheckOut();
    notifyListeners();
    return result["success"];
  }

  Future<String> checkInCameraDevice(
      Map<String, dynamic> data, File image) async {
    data["RequestAction"] = "AddCheckLog";
    data["token"] = _token;
    data["employeeId"] = _employeeId;
    final result = await addCheckLogCameraDevice(_token, data, image);
    await getNewData();
    isTodayCheckIn = isCheckin();
    checkinTime = timeCheckIn();
    checkoutTime = timeCheckOut();
    notifyListeners();
    return result["success"];
  }

  Future getNewData() async {
    listData = await getData();
  }

  bool isCheckin() {
    return listData
        .where((element) => isSameDay(element.dateTime, DateTime.now()))
        .isNotEmpty;
  }

  String timeCheckIn() {
    var a = listData
        .where((element) => isSameDay(element.dateTime, DateTime.now()));
    if (a.isEmpty) {
      return "";
    }
    return a.first.time;
  }

  String timeCheckOut() {
    var a = listData
        .where((element) => isSameDay(element.dateTime, DateTime.now()));
    if (a.isEmpty) {
      return "";
    }
    // Fix bug 10/9/2023 create by Hoang Nguyen
    // if (a.last.time == a.first.time) {
    //   return "";
    // }
    return a.last.time;
  }
}
