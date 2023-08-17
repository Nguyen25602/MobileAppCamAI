import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:intl/intl.dart';

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

  String _getDate(DateTime date) {
    return "${date.year}/${date.month}/${date.day}";
  }

  String _getTime(DateTime date) {
    return "${date.hour}:${date.minute}:${date.second}";
  }

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

  Map<String, String> toMap() {
    return {
      "device_name": _device.formatString,
      "detected_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(_date),
    };
  }
}

var dataExmaple = {
  "success": "1",
  "data": [
    {
      "cpemployeecheckinlogid": "2298",
      "name": "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-01 7:25:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-01 07:25:42",
      "place_name": "Company",
      "device_id": "Camera",
      "device_name": "Camera",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2298",
      "name": "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-06 7:22:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-06 07:22:42",
      "place_name": "Company",
      "device_id": "Camera",
      "device_name": "Camera",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2299",
      "name":
          "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-06 11:22:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-06 11:22:42",
      "place_name": "Company",
      "device_id": "Camera",
      "device_name": "Camera",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2300",
      "name":
          "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-06 16:22:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-06 16:22:42",
      "place_name": "Company",
      "device_id": "Camera",
      "device_name": "Camera",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2301",
      "name":
          "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-06 17:32:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-06 17:32:42",
      "place_name": "Company",
      "device_id": "Camera",
      "device_name": "Camera",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2302",
      "name": "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-07 8:32:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-07 08:32:42",
      "place_name": "Company",
      "device_id": "GPS",
      "device_name": "GPS",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2303",
      "name":
          "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-07 12:32:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-07 12:32:42",
      "place_name": "Company",
      "device_id": "GPS",
      "device_name": "GPS",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2304",
      "name":
          "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-07 17:32:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-07 17:32:42",
      "place_name": "Company",
      "device_id": "GPS",
      "device_name": "GPS",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2305",
      "name": "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-08 7:32:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-08 07:32:42",
      "place_name": "Company",
      "device_id": "WIFI",
      "device_name": "WIFI",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2306",
      "name":
          "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-08 15:32:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-08 15:32:42",
      "place_name": "Company",
      "device_id": "WIFI",
      "device_name": "WIFI",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    },
    {
      "cpemployeecheckinlogid": "2307",
      "name":
          "Trần Thiên Tường (bonlovely2004@gmail.com) - 2023-08-08 17:12:42",
      "users_department": "directors",
      "tags": "",
      "related_employee": "2236",
      "detected_id": "Employee:2236",
      "detected_name": "Trần Thiên Tường (bonlovely2004@gmail.com)",
      "detected_time": "2023-08-08 17:12:42",
      "place_name": "Company",
      "device_id": "WIFI",
      "device_name": "WIFI",
      "tracking_id": "",
      "detected_image": "",
      "matching_percent": ""
    }
  ]
};
