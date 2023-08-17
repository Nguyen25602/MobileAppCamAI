// ignore_for_file: file_names

import 'package:flutter/material.dart';

class User {
  late String _token;
  late String _id;
  late String _fullName;
  late String _firstName;
  late String _email;
  late String _mobile;
  late String _userName;
  late String _birthday;
  late String? _avatar;
  late String _createdtime;
  late String _cpemployeeGender;
  late String _temporaryAddress;
  User.fromMap(Map<String, dynamic> maps) {
    _token = maps['token'];
    _id = maps['user_info']['id'];
    _fullName = maps['user_info']['full_name'];
    _userName = maps['user_info']['user_name_app'];
    _temporaryAddress = maps['user_info']['temporary_address'];
    _email = maps['user_info']['email'];
    _mobile = maps['user_info']['mobile'];
    _birthday = maps['user_info']['birthday'];
    _firstName = maps['user_info']['firstname'];
    _avatar = maps['user_info']['avatar'];
    _createdtime = maps['user_info']['createdtime'];
    _cpemployeeGender = maps['user_info']['cpemployee_gender'];
  }
  String get id => _id;
  String get token => _token;
  String get name => _fullName;
  String get userName => _userName;
  String get gmail => _email;
  String get mobile => _mobile;
  String get temporaryAddress => _temporaryAddress;
  String get birthday => _birthday;
  String? get avatar => _avatar;
  String get createdTime => _createdtime;
  String get gender => _cpemployeeGender;
  String get firstName => _firstName;

  void updateUserInfo(Map<String, dynamic> userInfo) {
    _id = userInfo['id'];
    _fullName = userInfo['full_name'];
    _email = userInfo['email'];
    _mobile = userInfo['mobile'];
    _birthday = userInfo['birthday'];
    _temporaryAddress = userInfo['temporary_address'];
    _firstName = userInfo['firstname'];
    _avatar = userInfo['avatar'];
    _createdtime = userInfo['createdtime'];
    _cpemployeeGender = userInfo['cpemployee_gender'];
  }

  void updateAtribute(String name) {
    _fullName = name;
  }
}

class UserProvider extends ChangeNotifier {
  User? user;
  UserProvider();
  // Hàm này sẽ được gọi từ các trang hay thành phần cần thay đổi thông tin người dùng
  void updateUser(Map<String, dynamic> userInfo) {
    user?.updateUserInfo(userInfo);
    // Gọi notifyListeners để thông báo cho các widget có sử dụng UserProvider biết là dữ liệu đã thay đổi.
    notifyListeners();
  }

  void updateName(String name) {
    user?.updateAtribute(name);
    notifyListeners();
  }

  void updateUserStart(User userNew) {
    user = userNew;
    notifyListeners();
  }

  void clear() {
    user = null;
  }
}
