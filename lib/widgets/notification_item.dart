import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:cloudgo_mobileapp/object/CheckIn.dart';
abstract class Notification {

  Widget build();
  Widget buildBluePrint(Widget leadingIcon, String text1, String text2, String text3, String text4, String time) {
    return Padding(
      padding: EdgeInsets.all(MarginValue.small/2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          leadingIcon,
          const SizedBox(width: 10,),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  overflow: TextOverflow.visible,
                  TextSpan(
                    text: text1,
                    children: [
                      TextSpan(
                        text: text2,
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(text: text3),
                      TextSpan(text: text4,
                        style: TextStyle(fontWeight: FontWeight.bold))
                    ]
                  ),
                  style: TextStyle(color: Constants.textColor),
                ),
                const SizedBox(height: 5,),
                Text(
                  time,
                  style: TextStyle(
                    color: Constants.textColor,
                    fontSize: 12,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w300
                  ),
                ),
              ],            
            )
          )
        ],
      ),
    );
  }
}

class StaffNotification extends Notification {
  @override
  Widget build() {
    return Container();
  }
}

class ManagerNotification extends Notification {
  Request _request;
  ManagerNotification({required Request request}): _request = request ;
  @override
  Widget build() {
    return super.buildBluePrint(
      Container(
        width: 48,
        height: 48,
        decoration:const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: AssetImage("assets/logo.png"))
        ),
      ),
      "Đơn xin nghỉ phép của ",
      _request.name,
      " đã được gửi đến cho bạn",
      "",
      "hôm qua"
    );
  }
}

class CheckInNotification extends StaffNotification {
  CheckIn _checkIn;

  CheckInNotification({required CheckIn checkIn}) : _checkIn = checkIn;

  @override
  Widget build() {
    return super.buildBluePrint(
      Icon(Icons.check, color: Colors.greenAccent[700],size: 48),
      "Bạn đã clock in thành công ngày ",
      _checkIn.formatDate(),  
      " vào lúc ",
      _checkIn.time,
      "Hôm nay"
    );
  }
}

class RequestNotification extends StaffNotification {
  Request _request;
  RequestNotification({required Request request}): _request = request;

  @override
  Widget build() {
    return super.buildBluePrint(
      _request.state == StateOFRequest.accept ?
        Icon(Icons.check, color: Colors.greenAccent[700],size: 48,):  Icon(Icons.close, color: Colors.red[700],size: 48,),
      "Đơn xin nghỉ phép vào ngày ",
      _request.formatEndDateAndStartDate(),
      _request.state == StateOFRequest.accept ? " đã được chấp nhận" : " đã bị từ chối",
      "",
      "Hôm nay"
    );
  }
}