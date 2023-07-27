import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';

class CheckIn {
  DateTime _date;
  TypeDevice _device;
  CheckIn({required DateTime date, required TypeDevice device}): _date = date, _device = device;

  String _getDate(DateTime date) {
    return "${date.year}/${date.month}/${date.day}";
  }
  String _getTime(DateTime date) {
    return "${date.hour}:${date.minute}:${date.second}";
  }

  String get date => _getDate(_date);
  String get time => _getTime(_date);
  DateTime get dateTime => _date;
  TypeDevice get device => _device;
  String formatDate() {
    if(_getDate(_date) == _getDate(DateTime.now())) {
      return "hôm nay";
    }
    return _getDate(_date);
  }
}