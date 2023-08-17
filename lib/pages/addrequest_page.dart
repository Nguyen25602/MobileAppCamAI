import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../object/Request.dart';

final managers = [
  {"id": "1", "name": "Lâm Bùi", "gmail": "lam.cloudgo.com"},
  {"id": "2", "name": "Tường Trần", "gmail": "tuongcrm.cloudgo.com"},
  {"id": "3", "name": "Admin", "gmail": "adim.gmail.com"},
  {"id": "4", "name": "Sự Nguyễn", "gmail": "nguyensu@gmail.cloudgo.com"},
];

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  DateTime? _startDay = DateTime.now();
  DateTime? _endDay = DateTime.now();
  String? _reason;
  TimeOffType _type = TimeOffType.workFromHome;
  DistanceOffType? _distanceOffType = DistanceOffType.oneDay;
  Period? _period;
  String? _title;
  String? _idApprovedPerson;

  List<String> timeoffTypes = List.generate(TimeOffType.values.length,
      (index) => TimeOffType.values[index].formatString);
  final _timeOffTypeController = TextEditingController();
  final _timeOffController = TextEditingController();
  final _distanceOffTypeController = TextEditingController();
  final _periodController = TextEditingController();
  // ignore: unused_field
  final _approvdePersonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _timeOffTypeController.text = _type.formatString;
    _distanceOffTypeController.text = DistanceOffType.oneDay.formatString;
    if (_isSameDay(_startDay, _endDay)) {
      _timeOffController.text =
          "${_startDay!.day}/${_startDay!.month}/${_startDay!.year}";
    } else {
      _timeOffController.text =
          "${_startDay!.day}/${_startDay!.month}/${_startDay!.year} - ${_endDay!.day}/${_endDay!.month}/${_endDay!.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
        leading: const BackButton(
          color: Constants.textColor,
        ),
        centerTitle: true,
        title: const Text(
          "TẠO NGHỈ PHÉP",
          style: TextStyle(
              color: Constants.textColor,
              fontSize: 18,
              fontFamily: 'roboto',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: MarginValue.medium),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: MarginValue.medium),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFormComponent(
                            "Tiêu đề",
                            "",
                            "",
                            "Nhập tiêu đề",
                            false,
                            null,
                            null,
                            1,
                            (newValue) => _title = newValue,
                            null),
                      ],
                    )),
                spacer(),
                divider(),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: MarginValue.medium),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label("Loại đơn nghỉ phép"),
                        tableRadioButton(),
                      ],
                    )),
                spacer(),
                divider(),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: MarginValue.medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label("Thời gian nghỉ"),
                      spacer(MarginValue.medium),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: DropdownMenu<DistanceOffType>(
                                controller: _distanceOffTypeController,
                                label: const Text.rich(TextSpan(
                                    text: "Loại",
                                    style: TextStyle(fontSize: FontSize.small),
                                    children: [
                                      TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                              color: Constants.dangerousColor))
                                    ])),
                                dropdownMenuEntries: List.generate(
                                    DistanceOffType.values.length,
                                    (index) => DropdownMenuEntry(
                                        value: DistanceOffType.values[index],
                                        label: DistanceOffType
                                            .values[index].formatString)),
                                onSelected: (value) => setState(() {
                                  _distanceOffType = value;
                                  _startDay = _endDay = DateTime.now();
                                  _timeOffController.text =
                                      "${_startDay!.day}/${_startDay!.month}/${_startDay!.year}";
                                  if (value != DistanceOffType.halfDay) {
                                    _period = null;
                                    _periodController.text = '';
                                  } else {
                                    _period = Period.morning;
                                    _periodController.text =
                                        Period.morning.formatString;
                                  }
                                }),
                                inputDecorationTheme: InputDecorationTheme(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: MarginValue.small),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(width: 1),
                                    )),
                              ),
                            ),
                            const Flexible(child: SizedBox()),
                            Flexible(
                              child: DropdownMenu<Period>(
                                controller: _periodController,
                                label: const Text.rich(TextSpan(
                                    text: "Buổi",
                                    style: TextStyle(fontSize: FontSize.small),
                                    children: [
                                      TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                              color: Constants.dangerousColor))
                                    ])),
                                dropdownMenuEntries: List.generate(
                                    Period.values.length,
                                    (index) => DropdownMenuEntry(
                                        value: Period.values[index],
                                        label:
                                            Period.values[index].formatString)),
                                onSelected: (value) => setState(() {
                                  _period = value;
                                }),
                                enabled:
                                    _distanceOffType == DistanceOffType.halfDay,
                                inputDecorationTheme: InputDecorationTheme(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: MarginValue.small),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(width: 1),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: MarginValue.medium,
                            ),
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      textForm(
                          null,
                          "",
                          "Chọn thời gian",
                          true,
                          const Icon(Icons.arrow_forward_ios_outlined),
                          _timeOffController,
                          null,
                          null, () async {
                        List<DateTime?>? pickDate =
                            await showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                        calendarType: _distanceOffType ==
                                                DistanceOffType.manyDay
                                            ? CalendarDatePicker2Type.range
                                            : CalendarDatePicker2Type.single),
                                dialogSize: Size(width, 250));
                        if (pickDate != null) {
                          if (pickDate.length == 1) {
                            _startDay = _endDay = pickDate[0];

                            _timeOffController.text =
                                "${_startDay!.day}/${_startDay!.month}/${_startDay!.year}";
                          } else {
                            _startDay = pickDate[0];
                            _endDay = pickDate[1];

                            _timeOffController.text =
                                "${_startDay!.day}/${_startDay!.month}/${_startDay!.year} - ${_endDay!.day}/${_endDay!.month}/${_endDay!.year}";
                          }
                        }
                      }),
                    ],
                  ),
                ),
                spacer(),
                divider(),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: MarginValue.medium),
                  child: textFormComponent(
                      "Lý do",
                      "",
                      "Nhập chi tiết lý do nghỉ",
                      "Nhập lý do",
                      false,
                      null,
                      null,
                      5,
                      (newValue) => _reason = newValue,
                      null),
                ),
                spacer(),
                divider(),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: MarginValue.medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label("Giao cho"),
                      spacer(MarginValue.medium),
                      DropdownButtonFormField<String>(
                        value: _idApprovedPerson,
                        items: managers
                            .map((manager) => DropdownMenuItem(
                                  value: manager["id"]!,
                                  child: Text(
                                    "${manager["name"]} - ${manager["gmail"]}",
                                    style: const TextStyle(
                                        color: Constants.textColor,
                                        fontFamily: 'roboto',
                                        fontSize: FontSize.small,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _idApprovedPerson = value;
                          });
                        },
                        validator: (_) {
                          return _idApprovedPerson == null
                              ? "Chọn người gửi"
                              : null;
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: MarginValue.small),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(width: 1),
                            )),
                      )
                    ],
                  ),
                ),
                spacer(MarginValue.large),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //submit your request
                          Request request = Request(
                              idApprovedPerson: _idApprovedPerson!,
                              title: _title!,
                              name: user!.name,
                              start: _startDay ?? DateTime.now(),
                              end: _endDay ?? DateTime.now(),
                              type: _type,
                              distanceOffType:
                                  _distanceOffType ?? DistanceOffType.oneDay,
                              period: _period,
                              reason: _reason ?? " ",
                              createTime: DateTime.now());

                          context
                              .read<RequestRepository>()
                              .sendRequest(request.toMap())
                              .then((_) => Navigator.of(context).pop());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Constants.enableButton,
                          padding: const EdgeInsets.symmetric(
                              horizontal: MarginValue.large,
                              vertical: MarginValue.medium),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      child: const Text(
                        "Gửi yêu cầu",
                        style: TextStyle(
                            fontFamily: 'roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime? day1, DateTime? day2) {
    if (day1 == null || day2 == null) {
      return false;
    }

    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  Divider divider() {
    return const Divider(
      color: Constants.lineColor,
      thickness: 1,
    );
  }

  SizedBox spacer([double height = MarginValue.small]) {
    return SizedBox(
      height: height,
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: const TextStyle(
          color: Constants.textColor,
          fontSize: 14,
          fontFamily: 'roboto',
          fontWeight: FontWeight.w600),
    );
  }

  Widget textForm(String? initValue, String? hintText, String? labelText,
      [bool isReadOnly = true,
      Widget? suffixIcon,
      TextEditingController? controller,
      int? maxLines,
      void Function(String)? callBackOnChanged,
      void Function()? callBackOnTap]) {
    return TextFormField(
      readOnly: isReadOnly,
      controller: controller,
      initialValue: initValue,
      maxLines: maxLines,
      onChanged: callBackOnChanged,
      onTap: callBackOnTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText của bạn';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
            vertical: MarginValue.small, horizontal: MarginValue.small),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
            fontFamily: 'roboto',
            fontSize: FontSize.small,
            fontWeight: FontWeight.w300),
        label: Text(
          labelText ?? "",
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'roboto',
              fontSize: FontSize.small,
              fontWeight: FontWeight.w300),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1)),
      ),
      style: const TextStyle(
          color: Constants.textColor,
          fontFamily: 'roboto',
          fontSize: FontSize.small,
          fontWeight: FontWeight.normal),
    );
  }

  Widget textFormComponent(String labelString, String? initValue,
      String? hintText, String? labelText,
      [bool isReadOnly = true,
      Widget? suffixIcon,
      TextEditingController? controller,
      int? maxLines,
      void Function(String)? callBackOnChanged,
      void Function()? callBackOnTap]) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: MarginValue.medium),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            label(labelString),
            spacer(MarginValue.medium),
            textForm(initValue, hintText, labelText, isReadOnly, suffixIcon,
                controller, maxLines, callBackOnChanged, callBackOnTap)
          ]),
    );
  }

  Widget tableRadioButton() {
    List<TableRow> listRow = [];
    int count = 0;
    List<Widget> itemInRow = [];
    for (final element in TimeOffType.values) {
      count += 1;
      itemInRow.add(ListTile(
        minLeadingWidth: 10,
        horizontalTitleGap: 0,
        title: Text(
          element.formatString,
          style: const TextStyle(fontSize: FontSize.medium),
        ),
        leading: Radio<TimeOffType>(
            fillColor: MaterialStateColor.resolveWith((states) {
              if (states.any((element) => element == MaterialState.selected)) {
                return Constants.radioBtnSelectdColor;
              }
              return Constants.radioBtnBorderColor;
            }),
            value: element,
            groupValue: _type,
            onChanged: (newValue) => setState(() {
                  _type = newValue!;
                })),
      ));
      if (count == 2) {
        listRow.add(TableRow(children: itemInRow));
        count = 0;
        itemInRow = [];
      }
    }
    if (itemInRow.isNotEmpty) {
      itemInRow.add(const SizedBox());
      listRow.add(TableRow(children: itemInRow));
    }
    return Table(
      children: listRow,
    );
  }
}
