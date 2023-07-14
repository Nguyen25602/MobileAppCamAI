import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import '../object/Request.dart';

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  DateTime? _startDay = DateTime.now();
  DateTime? _endDay = DateTime.now();
  String? _reason;
  TimeOffType _type = TimeOffType.noSalary;
  StateOFRequest _state = StateOFRequest.waitting;

  List<String> timeoffTypes = List.generate(TimeOffType.values.length,
      (index) => TimeOffType.values[index].formatString);
  final _timeOffTypeController = TextEditingController();
  final _timeOffController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timeOffTypeController.text = _type.formatString;
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 3, // Chiều cao của đường thẳng
            width: double.infinity, // Đặt độ rộng thành vô hạn
            color: Constants.lineColor, // Màu sắc của đường thẳng
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
        ),
        centerTitle: true,
        title: Text(
          "NGHỈ PHÉP",
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
          padding: EdgeInsets.all(MarginValue.medium),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trần Thiên Tường",
                  style: TextStyle(
                      color: Constants.textColor,
                      fontFamily: 'roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                divider(),
                textFormComponent(
                    "Loại đơn",
                    null,
                    "",
                    "Chọn loại đơn",
                    true,
                    const Icon(Icons.arrow_forward_ios_outlined),
                    _timeOffTypeController,
                    null,
                    null, () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          content: SizedBox(
                            width: double.maxFinite,
                            height: 150,
                            child: ListView.builder(
                              itemCount: timeoffTypes.length,
                              itemBuilder: (context, index) {
                                return TextButton(
                                    onPressed: () {
                                      for (final value in TimeOffType.values) {
                                        if (timeoffTypes[index] ==
                                            value.formatString) {
                                          setState(() {
                                            _type = value;
                                            _timeOffTypeController.text =
                                                _type.formatString;
                                            Navigator.of(context).pop();
                                          });
                                          break;
                                        }
                                      }
                                    },
                                    child: Text(timeoffTypes[index]));
                              },
                            ),
                          ),
                          title: const SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                    image:
                                        AssetImage("assets/Logo_CloudGo.png")),
                                Icon(Icons.close),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                divider(),
                textFormComponent(
                    "Thời gian áp dụng đơn",
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
                          config: CalendarDatePicker2WithActionButtonsConfig(
                              calendarType: CalendarDatePicker2Type.range),
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
                divider(),
                textFormComponent(
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
                divider(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //submit your request
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.enableButton,
                        padding: EdgeInsets.symmetric(
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
    return Divider(
      color: Constants.lineColor,
      thickness: 1,
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
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
          return 'hãy nhập lí do nghỉ của bạn';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
            fontFamily: 'roboto', fontSize: 12, fontWeight: FontWeight.w300),
        label: Text(
          labelText ?? "",
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'roboto',
              fontSize: 12,
              fontWeight: FontWeight.w300),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1)),
      ),
      style: TextStyle(
          color: Constants.textColor,
          fontFamily: 'roboto',
          fontSize: 12,
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
      margin: EdgeInsets.symmetric(vertical: MarginValue.medium),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            label(labelString),
            const SizedBox(
              height: 20,
            ),
            textForm(initValue, hintText, labelText, isReadOnly, suffixIcon,
                controller, maxLines, callBackOnChanged, callBackOnTap)
          ]),
    );
  }
}
