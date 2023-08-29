import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/list_item_attribute.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/object/Request.dart';

class RequestItem extends StatefulWidget {
  const RequestItem({super.key, required Request item}) : _requestItem = item;
  final Request _requestItem;
  @override
  State<RequestItem> createState() => _RequestItemState();
}

class _RequestItemState extends State<RequestItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          children: [
            TableRow(
              children: [
                Attribute(
                  icon: Icons.work_outline,
                  color: Constants.enableButton,
                  infomation: "Tiêu đề: ${widget._requestItem.title}",
                  style: const TextStyle(
                      color: Constants.textColor,
                      fontFamily: 'roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                UnconstrainedBox(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: MarginValue.small),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Constants.enableButton)),
                    child: Text(
                      widget._requestItem.typeOff.formatString,
                      style: const TextStyle(
                          color: Constants.textColor,
                          fontFamily: 'roboto',
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Attribute(
        //   icon: Icons.work_outline,
        //   infomation: "Tiêu đề: ${widget._requestItem.title}",
        //   color: Constants.enableButton,
        //   style: const TextStyle(
        //       color: Constants.textColor,
        //       fontFamily: 'roboto',
        //       fontSize: 12,
        //       fontWeight: FontWeight.w600),
        // ),
        const SizedBox(
          height: MarginValue.small,
        ),
        Attribute(
          icon: Icons.calendar_month_outlined,
          infomation: "Thời gian: ${widget._requestItem.getTimeOff()}",
          style: const TextStyle(
              color: Constants.textColor,
              fontFamily: 'roboto',
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: MarginValue.small,
        ),
        Table(
          children: [
            TableRow(
              children: [
                Attribute(
                  icon: Icons.browse_gallery_outlined,
                  infomation:
                      "Đã gửi vào: ${widget._requestItem.getCreateTimeRequest()}",
                  style: const TextStyle(
                      color: Constants.textColor,
                      fontFamily: 'roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ),
                UnconstrainedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MarginValue.small),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border:
                            Border.all(color: widget._requestItem.state.color)),
                    child: Text(
                      widget._requestItem.state.formatString,
                      style: TextStyle(
                          color: widget._requestItem.state.color,
                          fontFamily: 'roboto',
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: MarginValue.small,
        ),
      ],
    );
  }

//format dd/mm/yy
}
