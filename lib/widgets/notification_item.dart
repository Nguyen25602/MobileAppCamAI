import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:cloudgo_mobileapp/pages/detailrequest_page.dart';
import 'package:cloudgo_mobileapp/repository/NotificationRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/object/Notification.dart' as ntf;
import 'package:provider/provider.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({super.key, required this.item});
  final ntf.Notification item;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () {
            if (!widget.item.isRead) {
              context
                  .read<NotificationRepository>()
                  .readNotification(widget.item.id);

              setState(() {
                widget.item.isRead = true;
              });
            }
            // if(widget.item.message)
            // Chuyển đến màn hình khi ấn vào Notification
            nextScreen(
                context,
                DetailRequestPage(
                    request: Request(
                        title: "dsa",
                        createTime: DateTime.now(),
                        end: DateTime.now(),
                        idApprovedPerson: "1",
                        name: "hahah",
                        reason: "ccx",
                        start: DateTime.now(),
                        type: TimeOffType.maternityOff,
                        distanceOffType: DistanceOffType.halfDay)));
          },
          tileColor: widget.item.isRead
              ? Constants.primaryColor
              : Color.fromARGB(62, 121, 121, 121),
          contentPadding: const EdgeInsets.only(left: MarginValue.small),
          isThreeLine: false,
          title: Padding(
            padding: const EdgeInsets.only(bottom: MarginValue.small),
            child: Text(
              widget.item.message,
              style: const TextStyle(
                  fontSize: FontSize.medium, fontWeight: FontWeight.w400),
              maxLines: 2,
            ),
          ),
          subtitle: Text(
            widget.item.getCreateTimeRequest(),
            style: const TextStyle(
                fontSize: FontSize.small,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w200),
          ),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Center(
              child: Icon(
                widget.item.iconData,
              ),
            ),
          ),
        ),
        const Divider(
          color: Constants.lineColor,
          thickness: 2,
          height: 2,
        ),
      ],
    );
  }
}
