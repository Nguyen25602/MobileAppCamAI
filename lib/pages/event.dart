class Event {
  final Map<String, dynamic> checkInOutData;
  Event({required this.checkInOutData});

  @override
  String toString() => checkInOutData.toString();
}

// final checkInOutData = {
//   'checkIn': '09:00 AM',
//   'checkOut': '05:00 PM',
//   'status': 1, // 1 đi đúng
// };

// final checkInOutData = {
//     DateTime.utc(2023, 07, 01): {
//       'checkIn': '09:00 AM',
//       'checkOut': '05:00 PM',
//       'status': 1, // 1 đi đúng
//     },
//     DateTime.utc(2023, 07, 01): {
//       'checkIn': '10:30 AM',
//       'checkOut': '06:30 PM',
//       'status': 0, // đi lỗi
//     },
//     DateTime.utc(2023, 07, 01): {
//       'checkIn': '10:30 AM',
//       'checkOut': '06:30 PM',
//       'status': 0, //đi lỗi
//     },
//     // Thêm các ngày khác tại đây (nếu cần)
//   };

// class Event {
//   final String title;
//   Event({required this.title});

//   @override
//   String toString() => title;
// }
