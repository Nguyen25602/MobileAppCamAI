import 'package:cloudgo_mobileapp/pages/checkin_history_page.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/repository/TimeKeepingRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/timekeeping_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:intl/intl.dart';

class TimekeepingHistoryPage extends StatefulWidget {
  const TimekeepingHistoryPage({super.key});

  @override
  State<TimekeepingHistoryPage> createState() => _TimekeepingHistoryPageState();
}

class _TimekeepingHistoryPageState extends State<TimekeepingHistoryPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  int? _selectedMonth = DateTime.now().month;
  late CheckinRepository _checkinRepository;
  late TimeKeepingRepository _timeKeepingRepository;
  late RequestRepository _requestRepository;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _checkinRepository = Provider.of(context);
    _requestRepository = Provider.of(context);
    _timeKeepingRepository = TimeKeepingRepository(_checkinRepository);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "LỊCH SỬ CHẤM CÔNG",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.40,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2023, 1, 1),
                lastDay: DateTime(2023, 12, 30),
                calendarFormat: _format,
                rowHeight: 40,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  markersMaxCount: 1,
                  rangeEndTextStyle: TextStyle(color: Colors.blue),
                  // Style Ngày chọn //
                  selectedTextStyle:
                      TextStyle(color: Constants.whiteTextColor, fontSize: 14),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  //Style ngày hôm nay
                  todayTextStyle:
                      TextStyle(color: Constants.whiteTextColor, fontSize: 14),
                  todayDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(
                      color: Constants.warningColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  defaultTextStyle: TextStyle(
                      color: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Constants.textColor)),
                headerStyle: HeaderStyle(
                  leftChevronIcon: const FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    color: Constants.textColor,
                    size: 14,
                  ),
                  rightChevronIcon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    color: Constants.textColor,
                    size: 14,
                  ),
                  // Button Format
                  titleCentered: true, // Text Date nằm giữa
                  formatButtonVisible: true,
                  formatButtonShowsNext:
                      false, //Ngăn không cho Format Show trước
                  //Title Header Calendar Style
                  titleTextStyle: const TextStyle(
                      color: Constants.textColor,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  formatButtonDecoration: BoxDecoration(
                    color: Constants.primaryColor,
                    border: Border.all(
                        color: Constants.radioBtnBorderColor, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  formatButtonTextStyle: const TextStyle(
                    color: Constants.radioBtnSelectdColor,
                  ),
                ),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onFormatChanged: (format) {
                  if (format != _format) {
                    setState(() {
                      _format = format;
                    });
                  }
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(selectedDay, _selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      nextScreen(context, CheckinHistory(day: selectedDay));
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;

                  setState(() {
                    _selectedMonth = focusedDay.month;
                  });
                },
                eventLoader: (day) {
                  for (final timeKeeping
                      in _timeKeepingRepository.listTimeKeeping) {
                    DateFormat format = DateFormat('dd/MM/yyyy');
                    if (isSameDay(day, format.parse(timeKeeping.day))) {
                      return [timeKeeping.state];
                    }
                  }
                  for (final leavingRequest
                      in _requestRepository.approvedRequest()) {
                    if (leavingRequest.endDate.difference(day).inDays >= 0 &&
                        leavingRequest.startDate.difference(day).isNegative) {
                      return [StateOFDay.off];
                    }
                  }
                  return [];
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty && events[0] != null) {
                      StateOFDay state = events[0] as StateOFDay;
                      return Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: state.color),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: StateOFDay.intime.color,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "ĐÚNG GIỜ",
                        style: TextStyle(
                            fontFamily: 'roboto',
                            fontSize: FontSize.verySmall,
                            color: Color(0xFFDDC834),
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: StateOFDay.late.color,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "ĐI TRỄ",
                        style: TextStyle(
                            fontFamily: 'roboto',
                            fontSize: FontSize.verySmall,
                            color: Color(0xFFDDC834),
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: StateOFDay.off.color,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "VẮNG",
                        style: TextStyle(
                            fontFamily: 'roboto',
                            fontSize: FontSize.verySmall,
                            color: Color(0xFFDDC834),
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: MarginValue.small, bottom: MarginValue.small),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: Color(0xFF008ECF),
                        size: 16,
                      ),
                      label: Text(
                        "Tháng ${_selectedMonth == DateTime.now().month || _selectedMonth == null ? "này" : "$_selectedMonth"}",
                        style: const TextStyle(
                            color: Color(0xFF008ECF),
                            fontSize: FontSize.small,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF008ECF), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    _timeKeepingRepository
                            .getDataByMonth(_selectedMonth!)
                            .isNotEmpty
                        ? SizedBox(
                            height: 200,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        nextScreen(
                                            context,
                                            CheckinHistory(
                                                day: DateFormat("dd/MM/yyyy")
                                                    .parse(
                                                        _timeKeepingRepository
                                                            .listTimeKeeping[
                                                                index]
                                                            .day)));
                                      },
                                      child: TimeKeepingItem(
                                          timeKeeping: _timeKeepingRepository
                                              .getDataByMonth(
                                                  _selectedMonth!)[index]));
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    thickness: 2,
                                    color: Constants.lineColor,
                                  );
                                },
                                itemCount: _timeKeepingRepository
                                    .getDataByMonth(_selectedMonth!)
                                    .length),
                          )
                        : const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image:
                                      AssetImage("assets/cannot_find_data.jpg"),
                                  height: 200,
                                ),
                                SizedBox(
                                  height: MarginValue.small,
                                ),
                                Text(
                                  "Không tìm thấy dữ liệu của tháng này",
                                  style: TextStyle(
                                    fontSize: FontSize.large,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const Divider(
                      thickness: 2,
                      color: Constants.lineColor,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Thống kê chi tiết",
                      style: TextStyle(
                          color: Constants.textColor,
                          fontFamily: 'roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: MarginValue.medium),
                      child: _statisticTable(
                          hoursMonth:
                              _timeKeepingRepository.countHour(_selectedMonth!),
                          lateCount:
                              _timeKeepingRepository.countLate(_selectedMonth!),
                          goHomeEarlyCount: _timeKeepingRepository
                              .countHomeEarly(_selectedMonth!),
                          offRequestCount: _requestRepository
                              .countApproveRequest(_selectedMonth!)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: MarginValue.large,
              )
            ],
          ),
        ),
      ),
    );
  }

  //create statistic table for one month
  Text _label(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Constants.textColor,
          fontFamily: 'roboto',
          fontSize: 12,
          fontWeight: FontWeight.w300),
    );
  }

  Text _infomation(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Constants.textColor,
          fontFamily: 'roboto',
          fontSize: 12,
          fontWeight: FontWeight.w600),
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

  TableRow _tableSpacer(double distance) {
    return TableRow(children: [
      SizedBox(
        height: distance,
      ),
      SizedBox(
        height: distance,
      )
    ]);
  }

  Widget _statisticTable(
      {required double hoursMonth,
      int? lateCount,
      int? offRequestCount,
      int? offNoRequestCount,
      int? goHomeEarlyCount}) {
    String hoursMonthStringFormat = "${hoursMonth.toStringAsPrecision(2)} giờ";
    String lateCountStringFormat =
        "${lateCount == null ? "0" : "$lateCount"} lần";
    String goHomeEarlyCountStringFormat =
        "${goHomeEarlyCount == null ? "0" : "$goHomeEarlyCount"} lần";
    String offRequestCountStringFormat =
        "${offRequestCount == null ? "0" : "$offRequestCount"} lần";
    String offNoRequestCountStringFormat =
        "${offNoRequestCount == null ? "0" : "$offNoRequestCount"} lần";
    return Table(
      children: [
        TableRow(children: [
          _attribute(title: "Số giờ làm", content: hoursMonthStringFormat),
          const SizedBox(),
        ]),
        _tableSpacer(10),
        TableRow(children: [
          _attribute(title: "Đi trễ", content: lateCountStringFormat),
          _attribute(title: "Về sớm", content: goHomeEarlyCountStringFormat)
        ]),
        _tableSpacer(10),
        TableRow(children: [
          _attribute(title: "Nghỉ làm", content: offRequestCountStringFormat),
          _attribute(
              title: "Nghỉ không phép", content: offNoRequestCountStringFormat)
        ])
      ],
    );
  }
}
