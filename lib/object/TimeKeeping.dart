import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';

class TimeKeeping {
  late DateTime? _checkIn;
  late DateTime? _checkOut;
  TypeDevice _device = TypeDevice.camera;
  late StateOFDay _state;
  late double? _time;
  TimeKeeping({required CheckIn checkIn, required CheckIn checkOut}) {
    _checkIn = checkIn.dateTime;
    _checkOut = checkOut.dateTime;
    _device = checkIn.device;
    _time = _calTime();
    _state = _setState();
  }

  double? _calTime() {
    if (_checkOut == _checkIn) return 0;
    if (_checkOut != null) {
      double diff = _checkOut!
              .difference(_checkIn!.hour <= 8 && _checkIn!.hour <= 30
                  ? DateTime(
                      _checkIn!.year, _checkIn!.month, _checkIn!.day, 8, 30)
                  : _checkIn!)
              .inMinutes /
          60;
      if (_checkOut!.hour >= 13 && _checkOut!.minute >= 30) {
        diff = diff - 1.5;
      }

      return diff;
    }
    return null;
  }

  int getMonth() {
    return _checkIn!.month;
  }

  StateOFDay _setState() {
    if (_checkIn == null && _checkOut == null) {
      return StateOFDay.off;
    }
    if ((_checkIn!.hour <= 8 && _checkIn!.minute <= 30) ||
        (_checkIn!.hour >= 12 &&
            _checkIn!.hour <= 13 &&
            _checkIn!.minute <= 30)) {
      return StateOFDay.intime;
    }
    return StateOFDay.late;
  }

  bool isGoHomeEarly() {
    if (_checkOut == null) {
      return false;
    }
    return _checkOut!.hour <= 17 && _checkOut!.minute <= 30;
  }

  //"hh:mm"
  String _getTime(DateTime date) {
    return "${date.hour}:${date.minute}";
  }

  //"dd/MM/YYYY"
  String _getDay(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String get timeCheckIn => _getTime(_checkIn!);
  String get timeCheckOut => _getTime(_checkOut!);
  String get day => _getDay(_checkIn!);
  String get deviceCheckIn => _device.formatString;
  StateOFDay get state => _state;
  double get workTime => _time!;
}

enum TypeDevice {
  camera(formatString: "CAMERA"),
  gps(formatString: "GPS"),
  wifi(formatString: "WIFI");

  const TypeDevice({required this.formatString});
  final String formatString;
}

enum StateOFDay {
  late(formatString: "Trễ", color: Constants.warningColor),
  off(formatString: "Vắng", color: Constants.dangerousColor),
  intime(formatString: "Đúng giờ", color: Constants.successfulColor);

  const StateOFDay({required this.formatString, required this.color});
  final String formatString;
  final Color color;
}
