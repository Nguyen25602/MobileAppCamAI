import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:cloudgo_mobileapp/pages/checkIn_history_page.dart';
import 'package:cloudgo_mobileapp/pages/detailrequest_page.dart';
import 'package:cloudgo_mobileapp/repository/NotificationRepository.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/object/Notification.dart' as ntf;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({super.key, required this.item});
  final ntf.Notification item;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late RequestRepository _requestRepository;

  Future _start(BuildContext context) async {
    _requestRepository = Provider.of<RequestRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _start(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                    // Chuyển đến màn hình khi ấn vào Notification
                    if (widget.item.categlory["action"] ==
                        "employee_checkin_mobileapp") {
                      List<String> parts =
                          widget.item.categlory["checkin_time"].split(" ");
                      String datePart = parts[0];
                      DateTime dateTime = DateTime.parse(datePart);
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(dateTime);
                      nextScreen(
                          context,
                          CheckinHistory(
                              day: DateFormat("dd/MM/yyyy")
                                  .parse(formattedDate)));
                    }
                    if (widget.item.categlory["action"] == "employee_leaving") {
                      List<Request> a = _requestRepository.requests
                          .where(
                              (element) => element.id == widget.item.idLeaving)
                          .toList();
                      nextScreen(context, DetailRequestPage(request: a[0]));
                    }
                  },
                  tileColor: widget.item.isRead
                      ? Constants.primaryColor
                      : Color.fromARGB(62, 121, 121, 121),
                  contentPadding:
                      const EdgeInsets.only(left: MarginValue.small),
                  isThreeLine: false,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: MarginValue.small),
                    child: Text(
                      widget.item.message,
                      style: const TextStyle(
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w400),
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
          return const Center(child: CircularProgressIndicator());
        });
  }
}
