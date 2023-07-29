import 'package:cloudgo_mobileapp/pages/addrequest_page.dart';
import 'package:cloudgo_mobileapp/pages/detailrequest_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/widgets/request_item.dart';
import 'package:cloudgo_mobileapp/object/Request.dart';
import '../widgets/widgets.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => RequestPageState();
}

class RequestPageState extends State<RequestPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  final List<Request> requests = [
    Request(
        name: "Hoàng Phước gia Nguyên",
        start: DateTime(2023, 8, 10),
        end: DateTime(2023, 8, 15),
        type: TimeOffType.annualLeave,
        reason: "Thăm gia đình"),
    Request(
        name: "Hoàng Phước gia Nguyên",
        start: DateTime(2023, 8, 26),
        end: DateTime(2023, 8, 26),
        type: TimeOffType.workFromHome,
        reason: "Bị ốm",
        state: StateOFRequest.accept),
    Request(
        name: "Hoàng Phước gia Nguyên",
        start: DateTime(2023, 9, 10),
        end: DateTime(2023, 9, 11),
        type: TimeOffType.diseasedOff,
        reason: "Thăm gia đình",
        state: StateOFRequest.accept),
    Request(
        name: "Hoàng Phước gia Nguyên",
        start: DateTime(2023, 9, 10),
        end: DateTime(2023, 9, 16),
        type: TimeOffType.maternityOff,
        reason: "Thăm gia đình",
        state: StateOFRequest.reject),
    Request(
        name: "Hoàng Phước gia Nguyên",
        start: DateTime(2023, 9, 10),
        end: DateTime(2023, 9, 16),
        type: TimeOffType.maternityOff,
        reason: "Thăm gia đình",
        state: StateOFRequest.reject),
    Request(
        name: "Hoàng Phước gia Nguyên",
        start: DateTime(2023, 9, 10),
        end: DateTime(2023, 9, 16),
        type: TimeOffType.diseasedOff,
        reason: "Có cuộc họp"),
  ];
  final items = const [
    Icons.house_outlined,
    Icons.photo_filter,
    Icons.content_paste_search_outlined,
    Icons.notifications_active_outlined,
  ];
  int _bottomIndex = 2;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F6),
        centerTitle: true,
        title: const Text(
          "YÊU CẦU NGHỈ PHÉP",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.40,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => nextScreen(context, const AddRequestPage()),
              icon: const Icon(
                Icons.add,
                color: Constants.enableButton,
              ))
        ],
        bottom: TabBar(isScrollable: true, controller: _controller, tabs: [
          tabLabel("Tất cả đơn"),
          tabLabel("Chờ duyệt"),
          tabLabel("Chấp thuận"),
          tabLabel("Từ chối")
        ]),
      ),
      body: Container(
        child: TabBarView(controller: _controller, children: [
          myRequestTab(context, requests, null),
          myRequestTab(context, requests, StateOFRequest.waitting),
          myRequestTab(context, requests, StateOFRequest.accept),
          myRequestTab(context, requests, StateOFRequest.reject),
        ]),
      ),
    );
  }

  Text tabLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        letterSpacing: 0.30,
      ),
    );
  }

  Widget myRequestTab(
      BuildContext context, List<Request> listItem, StateOFRequest? state) {
    List<Request> newList = listItem.where((element) {
      if (state == null) {
        return true;
      }
      return element.state == state;
    }).toList();

    return Container(
      margin: const EdgeInsets.only(
          top: MarginValue.medium, left: MarginValue.small),
      child: ListView.separated(
        itemCount: newList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () =>
                nextScreen(context, DetailRequestPage(request: newList[index])),
            child: RequestItem(item: newList[index]),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          thickness: 2.0,
          color: Constants.lineColor,
        ),
      ),
    );
  }
}
