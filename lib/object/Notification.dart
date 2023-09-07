//01/07/2023
//Thiên Tường
//Kiểu dữ liệu về thông báo sử dụng trên tầng UI

import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Gồm các thuộc tính thuộc tính:
//Nôi dụng thông báo
//Thời gian thông báo được gửi
//Tình trạng đã đọc hay chưa
//Id của thông báo được lưu trong database
//Icon để hiện thị

class Notification {
  final String message;
  final DateTime sendTime;
  final Map<String, dynamic> categlory;
  bool isRead;
  int id;
  String? idLeaving = "";
  IconData iconData = Icons.location_on_outlined;

  Notification(
      this.message, this.sendTime, this.isRead, this.id, this.categlory);
  Notification.fromMap(Map<String, dynamic> data)
      : message = data["message"],
        sendTime = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(data["data"]["created_time"]),
        isRead = data["data"]["read"] == "1",
        id = int.parse(data["data"]["id"]),
        categlory = data["data"]["extra_data"],
        idLeaving = data["data"]["extra_data"]["id"];

  //Trả về chuỗi định dạng cho thời gian thông báo được nhận đi
  //1 phút trước/ hôm qua/ 2 ngày trước ....
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

//Thông báo thuộc loại thông báo checkin
class NotificationCheckin extends Notification {
  NotificationCheckin(String message, DateTime dateTime, bool isRead, int id,
      Map<String, dynamic> categlory)
      : super(message, dateTime, isRead, id, categlory) {
    super.iconData = Icons.location_on_outlined;
  }
  NotificationCheckin.fromMap(Map<String, dynamic> data) : super.fromMap(data) {
    super.iconData = Icons.location_on_outlined;
  }
}

//Thông báo thuộc loại thông báo đơn nghỉ phép
class NotificationLeaving extends Notification {
  NotificationLeaving(String message, DateTime dateTime, bool isRead, int id,
      Map<String, dynamic> categlory)
      : super(message, dateTime, isRead, id, categlory) {
    super.iconData = Icons.request_quote_outlined;
    super.idLeaving = categlory['id'];
  }
  NotificationLeaving.fromMap(Map<String, dynamic> data) : super.fromMap(data) {
    super.iconData = Icons.request_quote_outlined;
  }
}

//Thông báo thuộc loại thông báo duyệt đơn nghỉ phép
//Là 1 TH đặc biệt của đơn nghỉ phép
//Có thêm 1 thuộc tính là được từ chối hay đồng ý
class NotificationApproveLeaving extends NotificationLeaving {
  final StateOFRequest stateOFRequest;
  NotificationApproveLeaving(String message, DateTime dateTime,
      this.stateOFRequest, bool isRead, int id, Map<String, dynamic> categlory)
      : super(message, dateTime, isRead, id, categlory) {
    super.iconData = stateOFRequest == StateOFRequest.reject
        ? Icons.highlight_off_outlined
        : Icons.offline_pin_outlined;
  }
  NotificationApproveLeaving.fromMap(Map<String, dynamic> data)
      : stateOFRequest =
            StateOFRequest.fromString(data["data"]["extra_data"]["status"]),
        super.fromMap(data) {
    super.iconData = stateOFRequest == StateOFRequest.reject
        ? Icons.highlight_off_outlined
        : Icons.offline_pin_outlined;
  }
}
