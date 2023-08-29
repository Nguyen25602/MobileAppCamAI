//01/07/2023
//Thien Tuong
//Kiểu dữ liệu về checkin sử dụng trên tầng UI
import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:intl/intl.dart';

//Gồm 2 thuộc tính:
//Thời gian checkin
//Thiết bị dùng để checkin
class CheckIn {
  final DateTime _date;
  final TypeDevice _device;
  CheckIn({required DateTime date, required TypeDevice device})
      : _date = date,
        _device = device;
  CheckIn.fromMap(Map<String, dynamic> json)
      : _date = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(json['detected_time'] as String),
        _device = _getTypeFromString(json['device_name'] as String);

  //hàm dùng để lấy ngày checkin
  String _getDate(DateTime date) {
    return "${date.year}/${date.month}/${date.day}";
  }

  //hàm dùng để lấy giờ checkin
  String _getTime(DateTime date) {
    return "${date.hour}:${date.minute}:${date.second}";
  }

  //Trả về loại thiết bị từ chuỗi nhập vào
  static TypeDevice _getTypeFromString(String type) {
    if (type == "GPS") return TypeDevice.gps;
    if (type == "WIFI") return TypeDevice.wifi;
    return TypeDevice.camera;
  }

  String get date => _getDate(_date);
  String get time => _getTime(_date);
  DateTime get dateTime => _date;
  TypeDevice get device => _device;

  String formatDate() {
    if (_getDate(_date) == _getDate(DateTime.now())) {
      return "hôm nay";
    }
    return _getDate(_date);
  }

  //Chuyển dổi từ Checkin -> json để đóng gói trong lúc gọi api
  Map<String, String> toMap() {
    return {
      "device_name": _device.formatString,
      "detected_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(_date),
    };
  }
}
