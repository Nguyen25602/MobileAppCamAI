import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final checkInOutData = {
    '2023-07-01': {
      'checkIn': '09:00 AM',
      'checkOut': '05:00 PM',
    },
    '2023-07-02': {
      'checkIn': '10:30 AM',
      'checkOut': '06:30 PM',
    },
    // Thêm các ngày khác tại đây (nếu cần)
  };

  final user = {
    'WiH9OQ0IdA2MVl155PB7': {
      'Name': 'Hoang Nguyen',
      'gmail': 'hpgnguyen20@clc.fitus.edu.vn',
      'sdt': '0852040256',
      'logCheck': [],
      'profilePic': '',
    },
    'WiH9OQ0IdA2MVl155PB1': {
      'Name': 'Hoang Nguyen',
      'gmail': 'hpgnguyen20@clc.fitus.edu.vn',
      'sdt': '0852040256',
      'logCheck': [123, 1323, 132],
      'profilePic': '123',
    },
  };

  final CollectionReference collectionReference1 =
      FirebaseFirestore.instance.collection('users');
  //Upload test firebase
  Future<void> uploadFirebase1() async {
    try {
      for (var entry in user.entries) {
        await collectionReference1.doc(entry.key).set(entry.value);
        // ignore: avoid_print
        print('Dữ liệu đã được tải lên Firestore');
      }
    } catch (error) {
      // ignore: avoid_print
      print('Lỗi khi tải lên dữ liệu: $error');
    }
  }

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('1234');

//Upload test firebase
  Future<void> uploadFirebase() async {
    try {
      for (var entry in checkInOutData.entries) {
        await collectionReference.doc(entry.key).set(entry.value);
        // ignore: avoid_print
        print('Dữ liệu đã được tải lên Firestore');
      }
    } catch (error) {
      // ignore: avoid_print
      print('Lỗi khi tải lên dữ liệu: $error');
    }
  }

  Future<QuerySnapshot?> getDateTime() async {
    try {
      QuerySnapshot querySnapshot = await collectionReference.get();
      return querySnapshot;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }
}

// Add Event Calendar 


