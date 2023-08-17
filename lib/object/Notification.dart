import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notification {
  final String message;
  final DateTime sendTime;
  bool isRead;
  IconData iconData = Icons.location_on_outlined;

  Notification(this.message, this.sendTime, this.isRead);
  Notification.fromMap(Map<String, dynamic> data)
      : message = data["message"],
        sendTime = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(data["data"]["created_time"]),
        isRead = data["data"]["read"] == "1";
  String getCreateTimeRequest() {
    var now = DateTime.now();
    var createTime = sendTime;
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
}

class NotificationCheckin extends Notification {
  NotificationCheckin(String message, DateTime dateTime, bool isRead)
      : super(message, dateTime, isRead);
  NotificationCheckin.fromMap(Map<String, dynamic> data) : super.fromMap(data) {
    super.iconData = Icons.location_on_outlined;
  }
}

class NotificationLeaving extends Notification {
  NotificationLeaving(String message, DateTime dateTime, bool isRead)
      : super(message, dateTime, isRead);
  NotificationLeaving.fromMap(Map<String, dynamic> data) : super.fromMap(data) {
    super.iconData = Icons.request_quote_outlined;
  }
}

class NotificationApproveLeaving extends NotificationLeaving {
  final StateOFRequest stateOFRequest;
  NotificationApproveLeaving(
      String message, DateTime dateTime, this.stateOFRequest, bool isRead)
      : super(message, dateTime, isRead);
  NotificationApproveLeaving.fromMap(Map<String, dynamic> data)
      : stateOFRequest =
            StateOFRequest.fromString(data["data"]["extra_data"]["status"]),
        super.fromMap(data) {
    super.iconData = stateOFRequest == StateOFRequest.reject
        ? Icons.highlight_off_outlined
        : Icons.offline_pin_outlined;
  }
}

final dataExample = {
  "success": "1",
  "entry_list": [
    {
      "message": "Bạn đã checkin lúc 16-08-2023 03:52 PM bằng GPS",
      "data": {
        "id": "66",
        "image": "",
        "related_record_id": "2520",
        "related_record_name": "Nguyễn Mai Anh",
        "related_module_name": "CPEmployee",
        "created_time": "2023-08-16 15:52:36",
        "read": "1",
        "extra_data": {
          "action": "employee_checkin_mobileapp",
          "checkin_time": "2023-08-16 15:52:32",
          "device": "GPS"
        }
      }
    },
    {
      "message":
          "Administrator đã từ chối đơn nghĩ phép: asadas vào lúc 16-08-2023 15:08",
      "data": {
        "id": "65",
        "image": "",
        "related_record_id": "2520",
        "related_record_name": "asadas",
        "related_module_name": "CPLeaving",
        "created_time": "2023-08-16 15:50:46",
        "read": "1",
        "extra_data": {
          "action": "employee_leaving",
          "created_time": "2023-08-16 15:08:46",
          "title": "asadas",
          "status": "Not approve",
          "name_manage": "Administrator"
        }
      }
    },
    {
      "message":
          "Bạn đã gửi đơn 2132132131 thành công lúcv 16-08-2023 03:49 PM",
      "data": {
        "id": "64",
        "image": "",
        "related_record_id": "2520",
        "related_record_name": "Nguyễn Mai Anh",
        "related_module_name": "CPEmployee",
        "created_time": "2023-08-16 15:49:52",
        "read": "0",
        "extra_data": {
          "action": "employee_leaving",
          "created_time": "2023-08-16 15:49:46",
          "title": "2132132131"
        }
      }
    },
    {
      "message":
          "Bạn đã gửi đơn <strong>21321321</strong> thành công lúc <strong>16-08-2023 03:45 PM</strong>",
      "data": {
        "id": "63",
        "image": "",
        "related_record_id": "2520",
        "related_record_name": "Nguyễn Mai Anh",
        "related_module_name": "CPEmployee",
        "created_time": "2023-08-16 15:46:10",
        "read": "0",
        "extra_data": {
          "action": "employee_leaving",
          "created_time": "2023-08-16 15:45:47",
          "title": "21321321"
        }
      }
    },
    {
      "message": "dscxcxz",
      "data": {
        "id": "62",
        "image": "",
        "related_record_id": "2520",
        "related_record_name": "Nguyễn Mai Anh",
        "related_module_name": "CPEmployee",
        "created_time": "2023-08-16 15:39:04",
        "read": "0",
        "extra_data": {
          "action": "employee_leaving",
          "created_time": "2023-08-16 15:38:56",
          "title": "asadas"
        }
      }
    },
  ],
  "unread_count": "3",
  "paging": {"next_offset": "20"}
};
