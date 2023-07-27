import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
class TimeKeeping {
  late DateTime? _checkIn;
  late DateTime? _checkOut;
  TypeDevice _device = TypeDevice.camera;
  late StateOFDay _state;
  late int? _time;
  TimeKeeping({required DateTime? checkIn, required DateTime? checkOut, required int time, required TypeDevice typeCheckIn}) {
    _checkIn = checkIn;
    _checkOut = checkOut;
    _device = typeCheckIn;
    _time = time;
    if(checkIn == null) {
      _state = StateOFDay.off;
    }else {
      if(checkIn.hour > 8 && checkIn.minute > 30) {
        _state = StateOFDay.late;
      }else {
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
  int get workTime => _time!;

}
enum TypeDevice {
  camera(formatString: "camera"),
  gps(formatString: "gps"),
  wifi(formatString: "wifi");

  const TypeDevice({required this.formatString});
  final String formatString;
}

enum StateOFDay {
  late(formatString: "Trễ", color:Constants.warningColor),
  off(formatString: "Vắng", color: Constants.dangerousColor),
  intime(formatString: "Đúng giờ", color: Constants.successfulColor);

  const StateOFDay({required this.formatString, required this.color});
  final String formatString;
  final Color color;
}