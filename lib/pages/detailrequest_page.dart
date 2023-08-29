import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailRequestPage extends StatelessWidget {
  const DetailRequestPage({super.key, required Request request})
      : _request = request;
  final Request _request;

  @override
  Widget build(BuildContext context) {
    bool checkState = _request.state == StateOFRequest.waitting ? true : false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đơn: ${_request.title}",
          style: const TextStyle(
              fontSize: FontSize.veryLarge,
              fontFamily: 'roboto',
              fontWeight: FontWeight.w800,
              color: Constants.textColor),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Theme.of(context).primaryColor,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
            left: MarginValue.small,
            top: MarginValue.medium,
            right: MarginValue.small),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thông tin chi tiết",
              style: TextStyle(
                color: Colors.black,
                fontSize: FontSize.large,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w800,
                letterSpacing: 0.28,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: MarginValue.medium, horizontal: MarginValue.medium),
              margin: const EdgeInsets.only(
                  bottom: MarginValue.medium, top: MarginValue.medium),
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Constants.lineColor))),
              child: _statisticTable(),
            ),
            const Text(
              "Lý do",
              style: TextStyle(
                color: Colors.black,
                fontSize: FontSize.large,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w800,
                letterSpacing: 0.28,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              readOnly: true,
              initialValue: _request.reason,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: FontSize.small,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.28),
              enabled: false,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1)),
              ),
            ),
            !checkState
                ? const SizedBox(
                    height: 15,
                  )
                : Container(),
            !checkState
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Người quản lý ghi chú: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: FontSize.large,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.28,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: _request.approvedDescription,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: FontSize.small,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.28),
                        enabled: false,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(width: 1)),
                        ),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Text _label(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black,
          fontSize: FontSize.medium,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w300,
          letterSpacing: 0.28),
    );
  }

  Text _infomation(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black,
          fontSize: FontSize.small,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.28),
    );
  }

  Widget _attribute({required String title, required String content}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label(title),
        const SizedBox(
          height: 10,
        ),
        _infomation(content)
      ],
    );
  }

  TableRow _tableSpacer(double height) {
    return TableRow(children: [
      SizedBox(
        height: height,
      ),
      SizedBox(
        height: height,
      )
    ]);
  }

  Widget _statisticTable() {
    return Table(
      children: [
        TableRow(children: [
          _attribute(title: "Nhân viên", content: _request.name),
          _attribute(
              title: "Ngày tạo",
              content:
                  DateFormat("yyyy/MM/dd HH:mm").format(_request.createTime)),
        ]),
        _tableSpacer(15),
        TableRow(children: [
          _attribute(title: "Thời gian", content: _request.getTimeOff()),
          _attribute(
              title: "Loại nghỉ phép", content: _request.typeOff.formatString),
        ]),
        _tableSpacer(15),
        TableRow(children: [
          _attribute(title: "Tình trạng", content: _request.state.formatString),
          _attribute(
              title: "Số ngày nghỉ",
              content: _request.numberOfLeavingDay.toString())
        ])
      ],
    );
  }
}
