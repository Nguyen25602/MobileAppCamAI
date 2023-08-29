import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloudgo_mobileapp/pages/addrequest_page.dart';
import 'package:cloudgo_mobileapp/pages/detailrequest_page.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/widgets/request_item.dart';
import 'package:cloudgo_mobileapp/object/Request.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => RequestPageState();
}

class RequestPageState extends State<RequestPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  // ignore: unused_field
  late RequestRepository _requestRepository;
  final FilterRequest filter = FilterRequest();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        setState(() {
          filter.refresh();
        });
      }
    });
  }

  Future _start(BuildContext context) async {
    _requestRepository = Provider.of<RequestRepository>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        elevation: 2,
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
            icon: Lottie.asset("assets/filter.json", height: 40),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  TextEditingController fromDayController = TextEditingController(
                      text: filter.fromDate == null
                          ? null
                          : "${filter.fromDate!.day}/${filter.fromDate!.month}/${filter.fromDate!.year}");
                  TextEditingController toDayController = TextEditingController(
                      text: filter.toDate == null
                          ? null
                          : "${filter.toDate!.day}/${filter.toDate!.month}/${filter.toDate!.year}");
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(MarginValue.small),
                      child: StatefulBuilder(
                        builder: (context, setBottomSheetState) =>
                            Stack(children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  "Bộ lọc",
                                  style: TextStyle(
                                    color: Constants.textColor,
                                    fontSize: FontSize.large,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              filterLabel("Loại nghỉ phép"),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filter.timeOffTyeCondition.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    horizontalTitleGap: 0,
                                    title: Text(
                                      filter.timeOffTyeCondition[index]
                                          .attributeName.formatString,
                                      style: const TextStyle(
                                          fontSize: FontSize.small,
                                          fontWeight: FontWeight.w400,
                                          color: Constants.textColor),
                                    ),
                                    leading: Checkbox(
                                      value: filter
                                          .timeOffTyeCondition[index].isCheck,
                                      onChanged: (value) =>
                                          setBottomSheetState(() {
                                        filter.timeOffTyeCondition[index]
                                            .check = value!;
                                      }),
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) {
                                        const Set<MaterialState>
                                            interactiveStates = <MaterialState>{
                                          MaterialState.pressed,
                                          MaterialState.hovered,
                                          MaterialState.focused,
                                          MaterialState.selected
                                        };
                                        if (states
                                            .any(interactiveStates.contains)) {
                                          return Constants
                                              .checkBoxSelectedColor;
                                        }
                                        return Constants.radioBtnBorderColor;
                                      }),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3.0)),
                                    ),
                                  );
                                },
                              ),
                              filterLabel("Sắp xếp theo thời gian gửi"),
                              ListTile(
                                minLeadingWidth: 10,
                                horizontalTitleGap: 0,
                                leading: Radio<Sort>(
                                  fillColor:
                                      MaterialStateColor.resolveWith((states) {
                                    if (states.any((element) =>
                                        element == MaterialState.selected)) {
                                      return Constants.radioBtnSelectdColor;
                                    }
                                    return Constants.radioBtnBorderColor;
                                  }),
                                  groupValue: filter.sort,
                                  onChanged: (value) => setBottomSheetState(() {
                                    filter.sort = value;
                                  }),
                                  value: Sort.increase,
                                ),
                                title: Text(
                                  Sort.increase.formatString,
                                  style: const TextStyle(
                                      color: Constants.textColor,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              ListTile(
                                minLeadingWidth: 10,
                                horizontalTitleGap: 0,
                                leading: Radio<Sort>(
                                  fillColor:
                                      MaterialStateColor.resolveWith((states) {
                                    if (states.any((element) =>
                                        element == MaterialState.selected)) {
                                      return Constants.radioBtnSelectdColor;
                                    }
                                    return Constants.radioBtnBorderColor;
                                  }),
                                  groupValue: filter.sort,
                                  onChanged: (value) => setBottomSheetState(() {
                                    filter.sort = value;
                                  }),
                                  value: Sort.decrease,
                                ),
                                title: Text(
                                  Sort.decrease.formatString,
                                  style: const TextStyle(
                                      color: Constants.textColor,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              filterLabel("Thời gian"),
                              const SizedBox(
                                height: 15,
                              ),
                              textForm(
                                  null,
                                  "từ ngày",
                                  null,
                                  true,
                                  const Icon(Icons.calendar_month_outlined),
                                  fromDayController,
                                  null,
                                  null, () async {
                                List<DateTime?>? pickDate =
                                    await showCalendarDatePicker2Dialog(
                                        context: context,
                                        config:
                                            CalendarDatePicker2WithActionButtonsConfig(
                                                calendarType:
                                                    CalendarDatePicker2Type
                                                        .single),
                                        dialogSize: Size(
                                            MediaQuery.of(context).size.width,
                                            250));
                                if (pickDate != null) {
                                  filter.fromDate = pickDate[0];
                                  fromDayController.text =
                                      DateFormat("dd/MM/yyyy")
                                          .format(filter.fromDate!);
                                }
                              }),
                              const SizedBox(
                                height: 10,
                              ),
                              textForm(
                                  null,
                                  "đến ngày",
                                  null,
                                  true,
                                  const Icon(Icons.calendar_month_outlined),
                                  toDayController,
                                  null,
                                  null, () async {
                                List<DateTime?>? pickDate =
                                    await showCalendarDatePicker2Dialog(
                                        context: context,
                                        config:
                                            CalendarDatePicker2WithActionButtonsConfig(
                                                calendarType:
                                                    CalendarDatePicker2Type
                                                        .single),
                                        dialogSize: Size(
                                            MediaQuery.of(context).size.width,
                                            250));
                                if (pickDate != null) {
                                  filter.toDate = pickDate[0];
                                  toDayController.text =
                                      DateFormat("dd/MM/yyyy")
                                          .format(filter.toDate!);
                                }
                              }),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        1 /
                                        8,
                                    width: MediaQuery.of(context).size.width *
                                        2 /
                                        5,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setBottomSheetState(
                                            () {
                                              filter.refresh();
                                              fromDayController.clear();
                                              toDayController.clear();
                                            },
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Constants
                                                    .checkBoxSelectedColor)),
                                        child: const Text(
                                          "Đặt lại",
                                          style: TextStyle(
                                            color:
                                                Constants.checkBoxSelectedColor,
                                            fontSize: FontSize.medium,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        1 /
                                        8,
                                    width: MediaQuery.of(context).size.width *
                                        2 /
                                        5,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Constants
                                                .checkBoxSelectedColor),
                                        child: const Text(
                                          "Áp dụng",
                                          style: TextStyle(
                                            color: Constants.primaryColor,
                                            fontSize: FontSize.medium,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
        bottom: TabBar(isScrollable: true, controller: _controller, tabs: [
          tabLabel("Tất cả đơn"),
          tabLabel("Chờ duyệt"),
          tabLabel("Chấp thuận"),
          tabLabel("Từ chối")
        ]),
      ),
      body: FutureBuilder(
          future: _start(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TabBarView(controller: _controller, children: [
                myRequestTab(
                    context,
                    context.select<RequestRepository, List<Request>>(
                        (repository) => repository.requests),
                    null),
                myRequestTab(
                    context,
                    context.select<RequestRepository, List<Request>>(
                        (repository) => repository.requests),
                    StateOFRequest.waitting),
                myRequestTab(
                    context,
                    context.select<RequestRepository, List<Request>>(
                        (repository) => repository.requests),
                    StateOFRequest.accept),
                myRequestTab(
                    context,
                    context.select<RequestRepository, List<Request>>(
                        (repository) => repository.requests),
                    StateOFRequest.reject),
              ]);
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => nextScreen(context, const AddRequestPage()),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
    var temp = filter.filter(newList);
    return Container(
      color: Colors.white10,
      margin: const EdgeInsets.only(
          top: MarginValue.medium, left: MarginValue.small),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: temp.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => nextScreen(
                      context, DetailRequestPage(request: temp[index])),
                  child: RequestItem(item: temp[index]),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                thickness: 2.0,
                color: Constants.lineColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text filterLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: Constants.textColor,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w600,
        ),
      );

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
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Constants.lineColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Constants.lineColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: const EdgeInsets.only(left: MarginValue.small),
        suffixIconColor: Constants.lineColor,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
            fontFamily: 'roboto',
            fontSize: FontSize.medium,
            fontWeight: FontWeight.w300),
        label: Text(
          labelText ?? "",
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'roboto',
              fontSize: FontSize.medium,
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
          fontSize: 12,
          fontWeight: FontWeight.normal),
    );
  }
}

class FilterRequest {
  final List<AttributeCheckBox<TimeOffType>> timeOffTyeCondition = [
    AttributeCheckBox(TimeOffType.annualLeave),
    AttributeCheckBox(TimeOffType.diseasedOff),
    AttributeCheckBox(TimeOffType.maternityOff),
    AttributeCheckBox(TimeOffType.workFromHome)
  ];
  DateTime? fromDate;
  DateTime? toDate;
  Sort? sort;
  //get list condition from checkbox
  List<AttributeCheckBox<TimeOffType>> _getCondition() {
    return timeOffTyeCondition.where((element) => element.isCheck).toList();
  }

  //return filter list
  List<Request> filter(List<Request> requests) {
    if (sort != null) {
      if (sort == Sort.increase) {
        requests.sort(
          (request1, request2) {
            if (request1.createTime.isAfter(request2.createTime)) {
              return 1;
            } else {
              if (isSameDay(request1.createTime, request2.createTime)) {
                return 0;
              } else {
                return -1;
              }
            }
          },
        );
      } else {
        requests.sort(
          (request1, request2) {
            if (request1.createTime.isAfter(request2.createTime)) {
              return -1;
            } else {
              if (isSameDay(request1.createTime, request2.createTime)) {
                return 0;
              } else {
                return 1;
              }
            }
          },
        );
      }
    }
    return requests.where((element) => validate(element)).toList();
  }

  //check if an element is satified
  bool validate(Request item) {
    var typeConditions = _getCondition();
    bool satifyCondition = true;
    //kiểm tra điều kiện checkbox
    if (typeConditions.isNotEmpty) {
      for (var condition in typeConditions) {
        if (condition.attributeName == item.typeOff) {
          satifyCondition = true;
          break;
        } else {
          satifyCondition = false;
        }
      }
    }

    //kiểm tra vs đk ngày bắt đầu
    if (fromDate != null) {
      if (isSameDay(fromDate, item.startDate)) {
        satifyCondition = true;
      } else {
        satifyCondition = false;
      }
    }

    //kiểm tra vs đk ngày kết thúc
    if (toDate != null) {
      if (isSameDay(toDate, item.endDate)) {
        satifyCondition = true;
      } else {
        satifyCondition = false;
      }
    }
    return satifyCondition;
  }

  void refresh() {
    fromDate = toDate = null;
    sort = null;
    for (var element in timeOffTyeCondition) {
      element.check = false;
    }
  }

  void checkCondition(TimeOffType type) {
    for (var condition in timeOffTyeCondition) {
      if (condition.attributeName == type) {
        condition.check = true;
      }
    }
  }
}

enum Sort {
  increase(formatString: "Tăng dần"),
  decrease(formatString: "Giảm dần");

  const Sort({required this.formatString});
  final String formatString;
}

class AttributeCheckBox<T> {
  bool _isCheck = false;
  final T _attributeName;

  AttributeCheckBox(T attributeName) : _attributeName = attributeName;
  T get attributeName => _attributeName;
  bool get isCheck => _isCheck;

  set check(bool check) {
    _isCheck = check;
  }
}
