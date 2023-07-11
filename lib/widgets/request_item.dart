import 'package:cloudgo_mobileapp/shared/constants.dart';
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
    return Container(
      height:  width / 2,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 40,
                child: Container(
                  margin: EdgeInsets.only(top: MarginValue.medium),
                  child: Container(
                    margin:EdgeInsets.symmetric(horizontal: MarginValue.medium) ,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset("assets/logo.png", fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              "  ${widget._requestItem.name}",
                              overflow: TextOverflow.ellipsis,
                              style:const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Roboto',
                                fontWeight:FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Icon(widget._requestItem.state.icon, color:  widget._requestItem.state.color,)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(MarginValue.medium),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:MainAxisAlignment.center ,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Table(
                      
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: labelWithInformation("Thời gian", "${dateTimetoString(widget._requestItem.startDate)} - ${dateTimetoString(widget._requestItem.endDate)}")
                                ),
                                TableCell(
                                  child:  labelWithInformation("Loại nghỉ phép ", widget._requestItem.typeOff.formatString, margin: MarginValue.small)
                                  )
                              ],
                            ),
                            TableRow(
                              children: [
                                SizedBox(height: MarginValue.small,),
                                SizedBox(height: MarginValue.small,)
                              ]
                            ),
                            TableRow(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    onPressed: (){}, 
                                    icon:const Icon(
                                      Icons.restore_from_trash_outlined,
                                      color: Colors.red,
                                    )
                                  ),
                                ),
                                TableCell(
                                  child: labelWithInformation("Lý do", widget._requestItem.reason, margin: MarginValue.small),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Text label(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Color(0xFF318DE9),
      fontSize: 15,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      letterSpacing: 0.30,
    ),
  );
}
Text information(String infor) {
  return Text(
    infor,
    style:const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      letterSpacing: 0.30,
    ),
    overflow: TextOverflow.ellipsis,
  );
}

//format dd/mm/yyyy
String dateTimetoString(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}
Widget labelWithInformation(String title, String infor, {double margin = 0}) {
  return Container(
    margin: EdgeInsets.only(left: margin),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label(title),
        information(infor),
      ],
    ),
  );
}