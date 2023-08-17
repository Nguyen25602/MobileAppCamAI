import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/checkin_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CheckinHistory extends StatefulWidget {
  const CheckinHistory({super.key, required DateTime day}) : _day = day;
  final DateTime _day;

  @override
  State<CheckinHistory> createState() => _CheckinHistoryState();
}

class _CheckinHistoryState extends State<CheckinHistory> {
  late final CheckinRepository _repository;

  _start(BuildContext context) async {
    _repository = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Constants.primaryColor,
        title: const Text(
          "LỊCH SỬ CHECKIN",
          style: TextStyle(
              color: Constants.textColor,
              fontSize: 18,
              fontFamily: 'roboto',
              fontWeight: FontWeight.w700),
        ),
      ),
      body: FutureBuilder(
        future: _start(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Có lỗi đã xảy ra, vui lòng thử lại!",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<CheckinRepository>(
              builder: (context, repository, child) {
                if (repository.filterByDay(widget._day).isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("assets/cannot_find_data.jpg"),
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
                        Text(
                          "Dữ liệu có thể đã bị xóa hoặc có sự lỗi bất ngờ xảy ra!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: FontSize.small),
                        )
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(MarginValue.medium),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF008ECF), width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                          child: Text(
                              DateFormat("dd/MM/yyyy").format(widget._day),
                              style: const TextStyle(
                                  color: Color(0xFF008ECF),
                                  fontSize: 14,
                                  fontFamily: 'roboto',
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: repository.filterByDay(widget._day).length,
                          separatorBuilder: (context, index) => const Divider(
                            color: Constants.lineColor,
                          ),
                          itemBuilder: (context, index) {
                            return CheckInItem(
                                item: _repository
                                    .filterByDay(widget._day)[index]);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
