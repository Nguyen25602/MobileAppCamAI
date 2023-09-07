import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final GlobalKey<ScaffoldState> _infoKey = GlobalKey<ScaffoldState>();
  final List<String> _avatarPaths = ['assets/cloudgo_icon.png'];
  XFile? image;
  String? _selectedGender;
  // ignore: unused_field
  String _userAvatar = "";
  String _name = "";
  // ignore: non_constant_identifier_names
  String _first_name = "";
  // ignore: non_constant_identifier_names
  String _last_name = "";
  String _user = '';
  String _number = '';
  String _email = '';
  String _address = '';
  // ignore: unused_field
  String _sex = '';

  bool _changeava = true;
  int _count = 0;
  bool button1valiable = true;
  bool button2valiable = false;

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  final TextEditingController _textEditingController3 = TextEditingController();
  final TextEditingController _textEditingController4 = TextEditingController();
  final TextEditingController _textEditingController5 = TextEditingController();

  String? _selectedDay = '25';
  String? _selectedMonth = '06';
  String? _selectedYear = '2002';

  void _updateDaysInMonth() {
    if (_selectedMonth == null || _selectedYear == null) {
      return;
    }

    int month = _months.indexOf(_selectedMonth!) + 1;
    int year = int.parse(_selectedYear!);

    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
      daysInMonth[1] = 29; // Năm nhuận
    }

    // Cập nhật danh sách ngày dựa trên số ngày trong tháng mới
    int selectedDay = _selectedDay != null ? int.parse(_selectedDay!) : 1;
    _days.clear();
    _days.addAll(List.generate(
        daysInMonth[month - 1], (index) => (index + 1).toString()));

    // Nếu ngày đã chọn vượt quá số ngày trong tháng mới thì reset ngày về 1
    if (selectedDay > daysInMonth[month - 1]) {
      _selectedDay = '1';
    }
  }

  final List<String> _days =
      List.generate(31, (index) => (index + 1).toString());
  final List<String> _months = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];
  final List<String> _years =
      List.generate(100, (index) => (2023 - index).toString());

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _clearTextField() {
    setState(() {
      _textEditingController.clear();
      _textEditingController2.clear();
      _textEditingController3.clear();
      _textEditingController4.clear();
      _textEditingController5.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final desiredWidth = screenWidth * 0.9;
    final desiredHeight = screenHeight * 0.8;

    return Scaffold(
      key: _infoKey,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Constants.primaryColor,
        title: const Text(
          "THÔNG TIN CÁ NHÂN",
          style: TextStyle(
            color: Constants.textColor,
            fontSize: 18,
            fontFamily: "roboto",
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) => Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: desiredWidth,
                  height: desiredHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        top: desiredHeight * 0.08,
                        right: desiredWidth * 0.05,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: desiredWidth * 0.9,
                          child: SizedBox(
                            width: desiredWidth * 0.05,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (button1valiable)
                                  Container(
                                    padding: const EdgeInsets.only(right: 10),
                                    alignment: Alignment.topRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          button1valiable = false;
                                          button2valiable = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child: const Icon(Icons.edit),
                                    ),
                                  ),
                                //if (!button1valiable) const SizedBox(height: 40),
                                SizedBox(
                                  height: desiredHeight * 0.05,
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      button2valiable
                                          ? TextFormField(
                                              enabled: button2valiable,
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                setState(() {
                                                  _name = value.toString();
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                labelText: '',
                                                alignLabelWithHint: true,
                                                labelStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Text(
                                              userProvider.user!.name,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: desiredHeight * 0.03,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        enabled: button2valiable,
                                        controller: _textEditingController,
                                        onChanged: (value) {
                                          setState(() {
                                            _user = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: button1valiable
                                              ? 'Username      : ${userProvider.user!.userName}'
                                              : 'Username',
                                          labelStyle:
                                              const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      TextField(
                                        enabled: button2valiable,
                                        controller: _textEditingController2,
                                        onChanged: (value) {
                                          setState(() {
                                            _number = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: button1valiable
                                              ? 'Số điện thoại : ${userProvider.user!.mobile}'
                                              : 'Số điện thoại',
                                          labelStyle:
                                              const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      TextField(
                                        enabled: button2valiable,
                                        controller: _textEditingController3,
                                        onChanged: (value) {
                                          setState(() {
                                            _email = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: button1valiable
                                              ? 'Email              : ${userProvider.user!.gmail}'
                                              : 'Email',
                                          labelStyle:
                                              const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      button2valiable
                                          ? _buildGenderSelection()
                                          : TextField(
                                              enabled: button2valiable,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Giới tính         : ${userProvider.user!.gender}',
                                                labelStyle: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                      button1valiable
                                          ? TextField(
                                              enabled: button2valiable,
                                              controller:
                                                  _textEditingController4,
                                              decoration: InputDecoration(
                                                labelText: button1valiable
                                                    ? 'Ngày sinh      : ${userProvider.user!.birthday}'
                                                    : 'Ngày sinh',
                                                labelStyle: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            )
                                          : _selecBirthday(),
                                      TextField(
                                        enabled: button2valiable,
                                        controller: _textEditingController5,
                                        onChanged: (value) {
                                          setState(() {
                                            _address = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: button1valiable
                                              ? 'Địa chỉ           : ${userProvider.user!.temporaryAddress}'
                                              : 'Địa chỉ',
                                          labelStyle:
                                              const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: desiredHeight * 0.05,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: ClipOval(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (button2valiable) {
                                  _changeava = false;
                                  _changeAvatar();
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(0),
                            ),
                            child: _changeava
                                ? userProvider.user!.avatar != ""
                                    ? Image.network(
                                        "http://api.cloudpro.vn${userProvider.user!.avatar}",
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.account_circle,
                                        size: 100,
                                      )
                                : Image.file(
                                    File(_avatarPaths.last),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (button2valiable)
                  SizedBox(
                    height: desiredHeight * 0.1,
                    width: desiredWidth * 0.9,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          button1valiable = true;
                          button2valiable = false;
                        });
                        _clearTextField();
                        userProvider.updateName(_name);
                        List<String> nameParts = _name.split(" ");
                        if (nameParts.length >= 2) {
                          // Lấy Họ và tên đệm
                          _first_name = nameParts
                              .sublist(0, nameParts.length - 1)
                              .join(" ");

                          // Lấy Tên cuối cùng
                          _last_name = nameParts.last;

                          print("Họ và tên đệm: $_first_name");
                          print("Tên: $_last_name");
                        }
                        final Map<String, dynamic> requestData = {
                          "RequestAction": "SaveProfile",
                          "Data": {
                            "mobile": _number,
                            "avatar": _avatarPaths,
                            "firstname": _last_name,
                            "lastname": _first_name,
                            "user_name_app": _user,
                            "temporary_address": _address,
                            "email": _email
                          },
                          "Avatar": image,
                          "id": userProvider.user!.id,
                        };
                        changeProfileEmployee(
                                userProvider.user!.token, requestData)
                            .then((value) => {
                                  if (value == "1")
                                    {
                                      showSnackbar(context, Colors.red,
                                          "Thay Đổi Thành Công")
                                    }
                                });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      child: const Text("Xác nhận"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changeAvatar() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _count += 1;
      Directory appDocumentsDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      String newImagePath =
          "${appDocumentsDirectory.path}/new_avatar${_count}.png";

      File(image!.path).copySync(newImagePath);
      setState(() {
        _avatarPaths.add(newImagePath);
        _userAvatar = _avatarPaths.last;
      });
    }
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giới tính:',
          style: TextStyle(fontSize: 12),
        ),
        Row(
          children: [
            _buildGenderRadioButton('Nam', 'Male'),
            _buildGenderRadioButton('Nữ', 'Female'),
            _buildGenderRadioButton('Khác', 'Khác'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderRadioButton(String title, String newValue) {
    return Row(
      children: [
        Radio<String>(
          value: newValue,
          groupValue: _selectedGender,
          onChanged: (String? value) {
            setState(() {
              _selectedGender = value;
              _sex = value.toString();
            });
          },
        ),
        Text(title),
      ],
    );
  }

  Widget _selecBirthday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ngày sinh'),
        Row(
          children: [
            // Dropdown ngày
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedDay,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDay = newValue;
                  });
                },
                items: _days.map((day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Ngày',
                ),
              ),
            ),
            // Dropdown tháng
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedMonth,
                onChanged: (newValue) {
                  setState(() {
                    _selectedMonth = newValue;
                    _updateDaysInMonth();
                  });
                },
                items: _months.map((month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Tháng',
                ),
              ),
            ),
            // Dropdown năm
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedYear,
                onChanged: (newValue) {
                  setState(() {
                    _selectedYear = newValue;
                    _updateDaysInMonth();
                  });
                },
                items: _years.map((year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Năm',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
