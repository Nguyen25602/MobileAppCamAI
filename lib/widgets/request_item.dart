import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/list_item.dart';
import 'package:cloudgo_mobileapp/widgets/list_item_attribute.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/object/Request.dart';


class RequestItem extends StatefulWidget {
  const RequestItem({super.key, required Request item})
    : _requestItem = item;
  final Request _requestItem;
  @override
  State<RequestItem> createState() => _RequestItemState();
}

class _RequestItemState extends State<RequestItem> {
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListItem(attributes: [
      Attribute(icon: Icons.work_outline, infomation: widget._requestItem.name, color: Constants.enableButton, style:const TextStyle(color: Constants.textColor,
        fontFamily: 'roboto',
        fontSize: 12,
        fontWeight: FontWeight.w400),),
      Attribute(icon: Icons.calendar_month_outlined, infomation: widget._requestItem.formatEndDateAndStartDate()),
      Attribute(icon: Icons.help_outline_outlined, infomation: widget._requestItem.state.formatString, style:  TextStyle( color: widget._requestItem.state.color,
        fontFamily: 'roboto',
        fontSize: 12,
        fontWeight: FontWeight.w300
        ),
      )
    ]
    );
  }


//format dd/mm/yy
}