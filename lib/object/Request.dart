import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';

enum TimeOffType {
  annualLeave(formatString: "Nghỉ phép năm"),
  diseasedOff (formatString: "Nghỉ bệnh"),
  maternityOff (formatString: "Nghỉ thai sản"),
  workFromHome(formatString:"Làm việc ở nhà");

  const TimeOffType(
    {required this.formatString
    }
  );

  final String formatString;
}

enum StateOFRequest {
  accept(formatString: "Đồng ý",icon: Icons.task_alt_outlined, color:  Constants.successfulColor),
  reject(formatString: "Từ chối",icon: Icons.dangerous_outlined, color:  Constants.dangerousColor),
  waitting(formatString: "Đợi duyệt",icon: Icons.hourglass_bottom_outlined, color:  Constants.warningColor);

  const StateOFRequest({
    required this.formatString,
    required this.icon,
    required this.color
  });
  final String formatString;
  final IconData icon;
  final Color color;
}

enum DistanceOffType {
  halfDay(formatString: "1/2 ngày"),
  oneDay(formatString: "1 ngày"),
  manyDay(formatString: "nhiều ngày");

  
  const DistanceOffType({required String this.formatString});
  final String formatString;

}

enum Period {
  morning(formatString: "Sáng"),
  afternoon(formatString: "Chiều");

  const Period({required String this.formatString});
  final String formatString;
}

class Request {
  String _name;
  DateTime _start;
  DateTime _end;
  TimeOffType _type;
  String _reason;
  StateOFRequest _state;
  DistanceOffType _distanceOffType;
  Period? _period;

  Request({required String name, 
  required DateTime start, 
  required DateTime end, 
  required TimeOffType type,
  required String reason, 
  DistanceOffType distanceOffType = DistanceOffType.oneDay,
  StateOFRequest state = StateOFRequest.waitting}) :
    _name = name,
    _start = start,
    _end = end,
    _type = type,
    _reason = reason,
    _distanceOffType = distanceOffType,
    _state = state;

  String get name => _name;
  DateTime get startDate => _start;
  DateTime get endDate => _end;
  TimeOffType get typeOff => _type;
  String get reason => _reason;
  StateOFRequest get state => _state;
  
  int get numberOfLeavingDay {
    var from = DateTime(_start.year, _start.month, _start.day);
    var to = DateTime(_end.year, _end.month, _end.day);
    return (to.difference(from).inHours / 24).round() + 1;
  }
  String _getDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
  String _getTime(DateTime date) {
    return "${date.hour}:${date.minute}:${date.second}";
  }

  String formatEndDateAndStartDate() {
    if(_getDate(_start) == _getDate(_end)) {
      return _getDate(_start);
    }else {
      return _getDate(_start) + " - " + _getDate(_end);
    }
  }

  
}