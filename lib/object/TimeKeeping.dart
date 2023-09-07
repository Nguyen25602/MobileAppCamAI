//01/07/2023
//Thiên Tường
//Kiểu dữ liệu về chấm công sử dụng trên tầng UI

import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';

//Gồm các thuộc tính
//Thời gian checkin
//Thời gian checkout
//thiết bị dùng để checkin
//Tình trạng của ngày hôm đó (đúng giờ/ vắng)
//Số giờ làm hôm đó
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

  //Thien Tuong
  //tính toán thời gian làm hôm đó
  /*
  * Nếu như chưa checkout -> trả về 0
  * Thời gian bắt đầu tính sẽ là max(8h30, checkin)
  * Thời gian kết thúc tính sẽ là min(17h30, checkout)
  * Nếu checkout sau 13h30 thì trừ đi 1.5h
  * thời gian làm hôm đó = kết thúc - bắt đầu - (1.5 || 0)
  */
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

  //Dữ liệu chấm công thuộc tháng nào
  int getMonth() {
    return _checkIn!.month;
  }

  //thay đổi tình trạng của ngày chấm công (trễ/ sớm)
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

  //Kiểu tra xem hôm đó có về sớm không
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
  String get timeCheckOut =>
      _getTime(_checkIn!) == _getTime(_checkOut!) ? "" : _getTime(_checkOut!);
  String get day => _getDay(_checkIn!);
  String get deviceCheckIn => _device.formatString;
  StateOFDay get state => _state;
  double get workTime => _time!;
}

//Các loại thiết bị cso thể dùng để checkin
enum TypeDevice {
  camera(formatString: "CAMERA"),
  gps(formatString: "GPS"),
  wifi(formatString: "WIFI"),
  cameradevice(formatString: "CameraDevice");

  const TypeDevice({required this.formatString});
  final String formatString;
}

//Tình trạng của ngày chấm công hôm đó
enum StateOFDay {
  late(formatString: "Trễ", color: Constants.warningColor),
  off(formatString: "Vắng", color: Constants.dangerousColor),
  intime(formatString: "Đúng giờ", color: Constants.successfulColor);

  const StateOFDay({required this.formatString, required this.color});
  final String formatString;
  final Color color;
}
