import 'package:flutter/material.dart';

enum TimeOffType {
  noSalary(formatString: "Nghỉ không lương"),
  hasSalary(formatString: "nghỉ có lương");

  const TimeOffType({required this.formatString});

  final String formatString;
}

enum StateOFRequest {
  accept(icon: Icons.task_alt_outlined, color: Colors.lightGreenAccent),
  reject(icon: Icons.dangerous_outlined, color: Colors.red),
  waitting(icon: Icons.hourglass_bottom_outlined, color: Colors.amber);

  const StateOFRequest({required this.icon, required this.color});
  final IconData icon;
  final Color color;
}

class Request {
  final String _name;
  final DateTime _start;
  final DateTime _end;
  final TimeOffType _type;
  final String _reason;
  final StateOFRequest _state;

  Request(
      {required String name,
      required DateTime start,
      required DateTime end,
      required TimeOffType type,
      required String reason,
      StateOFRequest state = StateOFRequest.waitting})
      : _name = name,
        _start = start,
        _end = end,
        _type = type,
        _reason = reason,
        _state = state;

  String get name => _name;
  DateTime get startDate => _start;
  DateTime get endDate => _end;
  TimeOffType get typeOff => _type;
  String get reason => _reason;
  StateOFRequest get state => _state;

  String _getDate(DateTime date) {
    return "${date.year}/${date.month}/${date.day}";
  }

  String _getTime(DateTime date) {
    return "${date.hour}:${date.minute}:${date.second}";
  }

  String formatEndDateAndStartDate() {
    if (_getDate(_start) == _getDate(_end)) {
      return _getDate(_start);
    } else {
      return _getDate(_start) + " đến ngày " + _getDate(_end);
    }
  }
}
