class CheckIn {
  DateTime _date;
  CheckIn({required DateTime date}): _date = date;

  String _getDate(DateTime date) {
    return "${date.year}/${date.month}/${date.day}";
  }
  String _getTime(DateTime date) {
    return "${date.hour}:${date.minute}:${date.second}";
  }

  String get date => _getDate(_date);
  String get time => _getTime(_date);

  String formatDate() {
    if(_getDate(_date) == _getDate(DateTime.now())) {
      return "hôm nay";
    }
    return _getDate(_date);
  }
}