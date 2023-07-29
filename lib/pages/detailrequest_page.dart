import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';

class DetailRequestPage extends StatelessWidget {
  const DetailRequestPage({super.key, required Request request})
      : this._request = request;
  final Request _request;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const BackButton(
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25.0),
          child: Text(
            _request.name,
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w600,
                color: Constants.textColor),
          ),
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
              "Thông tin chung",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
                letterSpacing: 0.28,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: MarginValue.medium),
              margin: const EdgeInsets.only(
                  bottom: MarginValue.medium, top: MarginValue.medium),
              decoration: const BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide())),
              child: _statisticTable(),
            ),
            const Text(
              "Lý do",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
                letterSpacing: 0.28,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              readOnly: true,
              initialValue: _request.reason,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1)),
              ),
            )
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
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w200,
          letterSpacing: 0.28),
    );
  }

  Text _infomation(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
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
          _attribute(title: "Ngày tạo", content: "15/5/2023 15:00"),
          _attribute(
              title: "Loại nghỉ phép", content: _request.typeOff.formatString),
        ]),
        _tableSpacer(10),
        TableRow(children: [
          _attribute(
              title: "Thời gian",
              content: _request.formatEndDateAndStartDate()),
          const SizedBox()
        ]),
        _tableSpacer(10),
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
