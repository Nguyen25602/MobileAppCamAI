// ignore: file_names
import 'package:flutter/material.dart';

class TimeKeeping {
  late DateTime? _checkIn;
  late DateTime? _checkOut;
  TypeDevice _device = TypeDevice.camera;
  late StateOFDay _state;
  TimeKeeping(
      {required DateTime? checkIn,
      required DateTime? checkOut,
      required TypeDevice typeCheckIn}) {
    _checkIn = checkIn;
    _checkOut = checkOut;
    _device = typeCheckIn;
    if (checkIn == null) {
      _state = StateOFDay.off;
    } else {
      if (checkIn.hour > 8 && checkIn.minute > 30) {
        _state = StateOFDay.late;
      } else {
        _state = StateOFDay.intime;
      }
    }
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
}

enum TypeDevice {
  camera(formatString: "camera"),
  gps(formatString: "gps"),
  wifi(formatString: "wifi");

  const TypeDevice({required this.formatString});
  final String formatString;
}

enum StateOFDay {
  late(formatString: "Trễ", color: Color(0xFFffa600)),
  off(formatString: "Vắng", color: Color(0xFFde425b)),
  intime(formatString: "Đúng giờ", color: Color(0xFF35bf8e));

  const StateOFDay({required this.formatString, required this.color});
  final String formatString;
  final Color color;
}
