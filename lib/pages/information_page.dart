import 'package:cloudgo_mobileapp/object/User.dart';
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
  final List<String> _avatarPaths = ['assets/logo.png'];
  String? _selectedGender;
  String _userAvatar = 'assets/logo.png';
  String _name = 'Hoàng Phước Gia Nguyên';
  String _user = 'nguyen.hoang';
  String _number = '0979074677';
  String _email = 'hoangnguyen@gmail.com';
  String _address = '37 Nguyễn Thị Thi';
  String _sex = 'Nam';
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
        leading: BackButton(),
        title: Text("THÔNG TIN CÁ NHÂN"),
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
                                              '${_name}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      const Text("Staff"),
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
                                              ? 'Username      : ${userProvider.user.gmail}'
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
                                              ? 'Số điện thoại : ${_number}'
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
                                              ? 'Email              : ${_email}'
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
                                                    'Giới tính         : ${_sex}',
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
                                                    ? 'Ngày sinh      : ${_selectedDay}/${_selectedMonth}/${_selectedYear}'
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
                                              ? 'Địa chỉ           : ${_address}'
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
                                ? Image.asset(
                                    _userAvatar,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
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
                      onPressed: () {
                        setState(() {
                          button1valiable = true;
                          button2valiable = false;
                        });
                        _clearTextField();
                        userProvider.updateName(_name);
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
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _count += 1;
      Directory appDocumentsDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      String newImagePath =
          "${appDocumentsDirectory.path}/new_avatar${_count}.png";

      File(image.path).copySync(newImagePath);
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
            _buildGenderRadioButton('Nam', 'Nam'),
            _buildGenderRadioButton('Nữ', 'Nữ'),
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
