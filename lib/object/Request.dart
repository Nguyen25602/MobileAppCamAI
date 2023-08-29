//01/07/2023
//Thiên Tường
//Kiểu dữ liệu về đơn nghỉ phép sử dụng trên tầng UI
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:intl/intl.dart';

//Thien Tuong
//Các loại nghỉ phép mà người dùng có thể chọn
enum TimeOffType {
  annualLeave(formatString: "Nghỉ phép năm", formatStringEnglish: "On leave"),
  diseasedOff(formatString: "Nghỉ bệnh", formatStringEnglish: "Sick leave"),
  maternityOff(
      formatString: "Nghỉ thai sản", formatStringEnglish: "Maternity leave"),
  workFromHome(formatString: "Làm việc ở nhà", formatStringEnglish: "WFH"),
  other(formatString: "Khác", formatStringEnglish: "Other");

  const TimeOffType(
      {required this.formatString, required this.formatStringEnglish});

  final String formatString;
  final String formatStringEnglish;
  //trả về loại nghỉ phép từ 1 chuôi cho trước
  factory TimeOffType.fromString(String name) {
    if (name.compareTo("On leave") == 0) {
      return TimeOffType.annualLeave;
    } else if (name.compareTo("WFH") == 0) {
      return TimeOffType.workFromHome;
    } else if (name.compareTo("Maternity leave") == 0) {
      return TimeOffType.maternityOff;
    } else if (name.compareTo("Sick leave") == 0) {
      return TimeOffType.diseasedOff;
    }
    return TimeOffType.other;
  }
}

//Các loại tình trạng của đơn nghỉ phép
enum StateOFRequest {
  accept(
      formatString: "Đồng ý",
      formatStringEnglish: "Approved",
      icon: Icons.task_alt_outlined,
      color: Constants.successfulColor),
  reject(
      formatString: "Từ chối",
      formatStringEnglish: "Not approve",
      icon: Icons.dangerous_outlined,
      color: Constants.dangerousColor),
  waitting(
      formatString: "Đợi duyệt",
      formatStringEnglish: "Wait approved",
      icon: Icons.hourglass_bottom_outlined,
      color: Constants.warningColor);

  const StateOFRequest(
      {required this.formatString,
      required this.formatStringEnglish,
      required this.icon,
      required this.color});
  final String formatString;
  final String formatStringEnglish;
  final IconData icon;
  final Color color;

  //trả về tình trạng của đơn nghỉ phép từ 1 chuôi cho trước
  factory StateOFRequest.fromString(String name) {
    if (name.compareTo("Not approve") == 0) {
      return StateOFRequest.reject;
    } else if (name.compareTo("Approved") == 0) {
      return StateOFRequest.accept;
    }
    return StateOFRequest.waitting;
  }
}

//Các loại thời gian nghỉ
enum DistanceOffType {
  halfDay(formatString: "1/2 ngày", formatStringEnglish: "Half day"),
  oneDay(formatString: "1 ngày", formatStringEnglish: "A Day"),
  manyDay(formatString: "nhiều ngày", formatStringEnglish: "Several days");

  const DistanceOffType(
      {required this.formatString, required this.formatStringEnglish});
  final String formatString;
  final String formatStringEnglish;

  //trả về loại ngày nghỉ từ 1 chuôi cho trước
  factory DistanceOffType.fromString(String name) {
    if (name.compareTo("Half day") == 0) {
      return DistanceOffType.halfDay;
    } else if (name.compareTo("Several days") == 0) {
      return DistanceOffType.manyDay;
    }
    return DistanceOffType.oneDay;
  }
}

//Buổi nghỉ khi loại thời gian nghỉ là nữa ngày
enum Period {
  morning(formatString: "Buổi sáng", formatStringEnglish: "Morning"),
  afternoon(formatString: "Buổi chiều", formatStringEnglish: "Afternoon");

  const Period({required this.formatString, required this.formatStringEnglish});
  final String formatString;
  final String formatStringEnglish;

  factory Period.fromString(String name) {
    if (name.compareTo("Afternoon") == 0) {
      return Period.afternoon;
    }
    return Period.morning;
  }
}

//Gồm các thuộc tính
//Tiêu đề đơn nghỉ phép
//Tên người gửi
//Ngày bắt đàu  //Nếu thời gian nghỉ là <= 1 ngày thì ngày bắt đầu giống ngày kết thúc
//Ngày kết thúc
//Lý do nghỉ
//Tình trạng đơn nghỉ
//Loại thời gian nghỉ (1 ngày/ nhiều ngày ...)
//Buổi nghỉ (nếu có)
//Thời gian đơn được tạo
//Được duyệt bởi ai
class Request {
  final String _title;
  late final String _name;
  late final DateTime _start;
  late final DateTime _end;
  final TimeOffType _type;
  final String _reason;
  final StateOFRequest _state;
  final DistanceOffType _distanceOffType;
  final Period? _period;
  final DateTime _createTime;
  final String _approvedBy;
  // ignore: unused_field
  String? _approvedDescription;
  Request({
    required String title,
    required String name,
    required DateTime start,
    required DateTime end,
    required TimeOffType type,
    required String reason,
    required DateTime createTime,
    Period? period,
    DistanceOffType distanceOffType = DistanceOffType.oneDay,
    StateOFRequest state = StateOFRequest.waitting,
    required String idApprovedPerson,
  })  : _title = title,
        _name = name,
        _start = start,
        _end = end,
        _type = type,
        _reason = reason,
        _distanceOffType = distanceOffType,
        _state = state,
        _createTime = createTime,
        _period = period,
        _approvedBy = idApprovedPerson;
  Request.fromMap({required Map data})
      : _title = data['name'],
        _type = TimeOffType.fromString(data['cpleaving_type']),
        _reason = data['description'],
        _distanceOffType =
            DistanceOffType.fromString(data['cpleavingdetail_type']),
        _state = StateOFRequest.fromString(data["cpleaving_status"]),
        _createTime =
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(data['createdtime']),
        _period = data["cpleavingdetail_time"].isEmpty
            ? null
            : Period.fromString(
                data["cpleavingdetail_time"],
              ),
        _approvedBy = "1", //cần thêm dữ liệu về người được giao khi call api*/
        _approvedDescription = data["approval_description"] {
    var dates = parseFromAndToDate(data['leaving_date']);
    if (dates.length == 1) {
      _start = _end = dates[0];
    } else {
      _start = dates[0];
      _end = dates[1];
    }
  }

  String get title => _title;
  String get name => _name;
  set name(String newName) {
    _name = newName;
  }

  DateTime get startDate => _start;
  DateTime get endDate => _end;
  TimeOffType get typeOff => _type;
  String get reason => _reason;
  StateOFRequest get state => _state;
  DistanceOffType get distanceOffType => _distanceOffType;
  DateTime get createTime => _createTime;
  String? get approvedDescription => _approvedDescription;

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
    if (_getDate(_start) == _getDate(_end)) {
      return _getDate(_start);
    } else {
      return "${_getDate(_start)} - ${_getDate(_end)}";
    }
  }

  String getCreateTimeRequest() {
    var now = DateTime.now();
    var createTime = _createTime;
    var difference = now.difference(createTime);
    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} phút trước";
    } else if (difference.inMinutes >= 60 && difference.inHours < 24) {
      return "${difference.inHours} giờ trước";
    } else if (difference.inHours >= 24 && difference.inDays < 30) {
      return "${difference.inDays} ngày trước";
    } else if (difference.inDays > 30 && difference.inDays < 366) {
      return "${difference.inDays ~/ 30} tháng trước";
    }
    return DateFormat("yyyy-MM-dd").format(createTime);
  }

  String getTimeOff() {
    if (_period != null) {
      return "${_getDate(_start)}: ${_period!.formatString}";
    }
    return formatEndDateAndStartDate();
  }

  List<DateTime> parseFromAndToDate(String data) {
    String removeSpaceFormat = data.replaceAll(RegExp(" "), "");
    if (_distanceOffType != DistanceOffType.manyDay) {
      int index = removeSpaceFormat.indexOf(':');
      String day = removeSpaceFormat.substring(0, index);
      return [DateFormat("dd-MM-yyyy").parse(day)];
    }
    int indexStartOfFromDay = removeSpaceFormat.lastIndexOf('Từ') + 2;
    int indexEndOfFromDay = removeSpaceFormat.indexOf("Đến");
    int indexStartOfToDay = removeSpaceFormat.lastIndexOf("Đến") + 3;
    int indexEndOfToDay = removeSpaceFormat.length;

    String fromDay =
        removeSpaceFormat.substring(indexStartOfFromDay, indexEndOfFromDay);
    String toDay =
        removeSpaceFormat.substring(indexStartOfToDay, indexEndOfToDay);
    DateFormat format = DateFormat("dd-MM-yyyy");
    return [format.parse(fromDay), format.parse(toDay)];
  }

  Map<String, String> toMap() {
    var dataRequest = <String, String>{};
    dataRequest["name"] = _title;
    dataRequest["cpleaving_type"] = _type.formatStringEnglish;
    dataRequest["cpleavingdetail_type"] = _distanceOffType.formatStringEnglish;
    dataRequest["description"] = _reason;
    dataRequest["assigned_user_id"] = _approvedBy;
    dataRequest["cpleavingdetail_time"] =
        _period == null ? "" : _period!.formatStringEnglish;
    dataRequest["from_day"] = DateFormat("dd-MM-yyyy").format(_start);
    dataRequest["to_day"] = _distanceOffType == DistanceOffType.manyDay
        ? DateFormat("dd-MM-yyyy").format(_end)
        : "";
    dataRequest["created_time"] =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(_createTime);
    print("Đã tạo đơn thành công" + dataRequest["created_time"]!);
    return dataRequest;
  }
}
