class TimeKeeping {
  late DateTime? _checkIn;
  late DateTime? _checkOut;
  TypeDevice _device = TypeDevice.camera;
  late StateOFDay _state;
  TimeKeeping({required DateTime? checkIn, required DateTime? checkOut, required TypeDevice typeCheckIn}) {
    _checkIn = checkIn;
    _checkOut = checkOut;
    _device = typeCheckIn;
    if(checkIn == null) {
      _state = StateOFDay.off;
    }else {
      if(checkIn.hour > 8 && checkIn.minute > 30) {
        _state = StateOFDay.late;
      }else {
        _state = StateOFDay.intime;
      }
    }
  }


  String _getTime(DateTime date) {
    return "${date.hour}:${date.minute}";
  }

  String get timeCheckIn => _getTime(_checkIn!);
  String get timeCheckOut => _getTime(_checkOut!);
  String get deviceCheckIn => _device.formatString;
  String get state => _state.formatString;

}
enum TypeDevice {
  camera(formatString: "camera"),
  gps(formatString: "gps"),
  wifi(formatString: "wifi");

  const TypeDevice({required this.formatString});
  final String formatString;
}

enum StateOFDay {
  late(formatString: "Trễ"),
  off(formatString: "Vắng"),
  intime(formatString: "Đúng giờ");

  const StateOFDay({required this.formatString});
  final String formatString;
}