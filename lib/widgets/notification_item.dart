import 'package:cloudgo_mobileapp/repository/NotificationRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
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
    final repository = Provider.of<NotificationRepository>(context);
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
                  .setUnreadNotify(repository.unreadNotify - 1);
              setState(() {
                widget.item.isRead = true;
              });
            }
          },
          tileColor: widget.item.isRead
              ? Constants.primaryColor
              : const Color(0xffF8F8F8),
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
