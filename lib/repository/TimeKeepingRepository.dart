import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';

import '../object/CheckIn.dart';

class TimeKeepingRepository {
  final CheckinRepository _checkinRepository;
  final List<TimeKeeping> _listTimeKeeping = [];

  List<TimeKeeping> get listTimeKeeping => _listTimeKeeping;

  TimeKeepingRepository(CheckinRepository repository)
      : _checkinRepository = repository {
    _getData();
  }

  void _getData() {
    List<DateTime> listDay = _checkinRepository.getValidateDay();
    for (var day in listDay) {
      List<CheckIn> checkinInDay = _checkinRepository.filterByDay(day);
      _listTimeKeeping.add(TimeKeeping(
          checkIn: checkinInDay.first, checkOut: checkinInDay.last));
    }
  }

  double countHour(int month) {
    double hours = 0;
    for (var element in _listTimeKeeping) {
      if (element.getMonth() == month) {
        hours += element.workTime;
      }
    }
    return hours;
  }

  int countLate(int month) {
    int count = 0;
    for (var element in getDataByMonth(month)) {
      if (element.state == StateOFDay.late) {
        count += 1;
      }
    }
    return count;
  }

  int countHomeEarly(int month) {
    int count = 0;
    for (var element in getDataByMonth(month)) {
      if (element.isGoHomeEarly()) {
        count += 1;
      }
    }
    return count;
  }

  List<TimeKeeping> getDataByMonth(int month) {
    int temp = month;
    return _listTimeKeeping
        .where((element) => element.getMonth() == temp)
        .toList();
  }
}
