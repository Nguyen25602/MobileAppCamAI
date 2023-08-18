//09/08/2023
//Thien Tuong
//các item hiển thị trong danh sách lịch sử chấm công

import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.attributes});
  //Trong item sẽ có nhiều thuộc tính
  final List<Widget> attributes;
  //nếu có ít thuộc tính (<= 3)thì sẽ hiển dưới dạng các hàng với mỗi hành 1 cột
  //nếu có nhiều thuộc tính thì sẽ hiển dưới dạng các hàng với mỗi hàng có 2 cột
  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = [];

    if (attributes.length <= 3 && attributes.isNotEmpty) {
      for (var element in attributes) {
        rows.add(TableRow(children: [element]));
        rows.add(const TableRow(children: [
          SizedBox(
            height: MarginValue.small,
          )
        ]));
      }
    } else if (attributes.length > 3) {
      rows.add(TableRow(children: [attributes[0], const SizedBox()]));
      rows.add(const TableRow(children: [
        SizedBox(
          height: MarginValue.small,
        ),
        SizedBox(
          height: MarginValue.small,
        )
      ]));

      int count = 0;
      List<Widget> attributePerRow = [];
      for (var i = 1; i < attributes.length; i++) {
        count += 1;
        attributePerRow.add(attributes[i]);
        if (count == 2) {
          rows.add(TableRow(children: attributePerRow));
          rows.add(const TableRow(children: [
            SizedBox(
              height: MarginValue.small,
            ),
            SizedBox(
              height: MarginValue.small,
            )
          ]));
          count = 0;
          attributePerRow = [];
        }
      }

      if (attributePerRow.isNotEmpty) {
        rows.add(TableRow(children: [attributePerRow[0], const SizedBox()]));
        rows.add(const TableRow(children: [
          SizedBox(
            height: MarginValue.small,
          ),
          SizedBox(
            height: MarginValue.small,
          )
        ]));
      }
    }
    return Table(
      children: rows,
    );
  }
}
