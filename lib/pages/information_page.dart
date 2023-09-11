import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloudgo_mobileapp/helper/helper_function.dart';
import 'package:cloudgo_mobileapp/main.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/pages/login_page.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/repository/NotificationRepository.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

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
  XFile? image;
  String? _selectedGender;
  // ignore: unused_field
  String _user = '';
  String _number = '';
  String _address = '';
  String _dob = '';
  String _password1 = '';
  String _password2 = '';
  // ignore: unused_field
  String _sex = '';
  DateTime? _startDay = DateTime.now();
  bool button1valiable = true;
  bool button2valiable = false;

  final TextEditingController _textUsername = TextEditingController();
  final TextEditingController _textPhone = TextEditingController();
  final TextEditingController _textBOD = TextEditingController();
  final TextEditingController _textAddress = TextEditingController();
  @override
  void dispose() {
    _textUsername.dispose();
    _textAddress.dispose();
    _textBOD.dispose();
    _textPhone.dispose();
    super.dispose();
  }

  void _clearTextField() {
    setState(() {
      _textUsername.clear();
      _textPhone.clear();
      _textBOD.clear();
      _textAddress.clear();
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
                                Center(
                                  child: Column(
                                    children: [
                                      if (button2valiable)
                                        const SizedBox(
                                          height: 50,
                                        ),
                                      Text(
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
                                        controller: _textUsername,
                                        onChanged: (value) {
                                          setState(() {
                                            _user = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: button1valiable
                                              ? 'Username      : ${userProvider.user!.userName}'
                                              : 'Tài khoản',
                                          labelStyle:
                                              const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      TextField(
                                        enabled: button2valiable,
                                        controller: _textPhone,
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
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText:
                                              'Email:               ${userProvider.user!.gmail}',
                                          labelStyle:
                                              const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      button2valiable
                                          ? _buildGenderSelection()
                                          : TextField(
                                              enabled: button2valiable,
                                              decoration: InputDecoration(
                                                labelText: userProvider
                                                            .user!.gender ==
                                                        "Male"
                                                    ? 'Giới tính         : Nam'
                                                    : 'Giới tính         : Nữ',
                                                labelStyle: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                      button1valiable
                                          ? TextField(
                                              enabled: button2valiable,
                                              controller: _textBOD,
                                              decoration: InputDecoration(
                                                labelText: button1valiable
                                                    ? 'Ngày sinh      : ${userProvider.user!.birthday}'
                                                    : 'Ngày sinh',
                                                labelStyle: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            )
                                          : textForm(
                                              null,
                                              "",
                                              "Ngày sinh",
                                              true,
                                              const Icon(Icons
                                                  .arrow_forward_ios_outlined),
                                              _textBOD,
                                              null,
                                              null, () async {
                                              List<DateTime?>? pickDate =
                                                  await showCalendarDatePicker2Dialog(
                                                      context: context,
                                                      config: CalendarDatePicker2WithActionButtonsConfig(
                                                          calendarType:
                                                              CalendarDatePicker2Type
                                                                  .single),
                                                      dialogSize: Size(
                                                          screenWidth, 250));
                                              if (pickDate != null) {
                                                if (pickDate.length == 1) {
                                                  _startDay = pickDate[0];
                                                  _textBOD.text =
                                                      "${_startDay!.day}-${_startDay!.month}-${_startDay!.year}";
                                                  _dob =
                                                      "${_startDay!.day}-${_startDay!.month}-${_startDay!.year}";
                                                }
                                              }
                                            }),
                                      TextField(
                                        enabled: button2valiable,
                                        controller: _textAddress,
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
                                        height: desiredHeight * 0.03,
                                      ),
                                      if (button2valiable)
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  if (_number.isEmpty &&
                                                      _user.isEmpty &&
                                                      _address.isEmpty &&
                                                      _dob.isEmpty) {
                                                    showErrorDialog(
                                                        context,
                                                        "Không có dữ liệu",
                                                        "Vui lòng nhập đúng");
                                                  } else {
                                                    showProcessWaiting(context);
                                                    setState(() {
                                                      button1valiable = true;
                                                      button2valiable = false;
                                                    });
                                                    _clearTextField();
                                                    final Map<String, dynamic>
                                                        requestData = {
                                                      "RequestAction":
                                                          "SaveProfile",
                                                      "Data": {
                                                        "mobile": _number,
                                                        "user_name_app": _user,
                                                        "temporary_address":
                                                            _address,
                                                        "birthday": _dob,
                                                      },
                                                      "id":
                                                          userProvider.user!.id,
                                                    };
                                                    await changeProfileEmployee(
                                                            userProvider
                                                                .user!.token,
                                                            requestData)
                                                        .then((value) => {
                                                              if (value?[
                                                                      'success'] ==
                                                                  "1")
                                                                {
                                                                  logoutEmployee(userProvider
                                                                          .user!
                                                                          .token)
                                                                      .then(
                                                                          (value) async =>
                                                                              {
                                                                                await HelperFunctions.saveUserLoggedInStatus(false),
                                                                                await HelperFunctions.saveAccessTokenSF(""),
                                                                                await HelperFunctions.saveUserNameSF(""),
                                                                                await HelperFunctions.saveEmployeeIdSF(""),
                                                                                context.read<UserProvider>().clear(),
                                                                                context.read<RequestRepository>().clear(),
                                                                                context.read<CheckinRepository>().clear(),
                                                                                context.read<NotificationRepository>().clear(),
                                                                                isSigned = false,
                                                                                if (value != null)
                                                                                  {
                                                                                    if (value["success"] == "1")
                                                                                      {
                                                                                        await showSuccessDialog(context, "Vui lòng đăng nhập lại"),
                                                                                        showSuccessLogout(context),
                                                                                      }
                                                                                    else
                                                                                      {
                                                                                        showSnackbar(context, Colors.blue, "Đăng xuất thất bại"),
                                                                                        Navigator.pop(context),
                                                                                      }
                                                                                  }
                                                                                else
                                                                                  {
                                                                                    showSnackbar(context, Colors.red, "Đã có thiết bị khác đăng nhập !!!"),
                                                                                    nextScreenRemove(context, const LoginPage())
                                                                                  }
                                                                              }),
                                                                }
                                                              else if (value?[
                                                                      'success'] ==
                                                                  "-1")
                                                                {
                                                                  showErrorDialog(
                                                                      context,
                                                                      "Tài khoản đăng nhập bị trùng",
                                                                      "Vui lòng nhập tài khoản mới",
                                                                      route:
                                                                          true),
                                                                }
                                                              else
                                                                {
                                                                  showErrorDialog(
                                                                      context,
                                                                      "Quá trình thay đổi thất bại",
                                                                      "Vui lòng thử lại sau"),
                                                                }
                                                            });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0)),
                                                ),
                                                child: const Text("Xác nhận"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Đổi mật khẩu'),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              margin: const EdgeInsets
                                                                      .only(
                                                                  top: MarginValue
                                                                      .medium,
                                                                  bottom:
                                                                      MarginValue
                                                                          .medium),
                                                              child:
                                                                  TextFormField(
                                                                obscureText:
                                                                    true,
                                                                decoration: textInputDecoration
                                                                    .copyWith(
                                                                        labelText:
                                                                            "Nhập Mật Khẩu",
                                                                        prefixIcon:
                                                                            const Icon(
                                                                          Icons
                                                                              .lock,
                                                                          color:
                                                                              Constants.textColor,
                                                                        )),
                                                                onChanged: (value) =>
                                                                    _password1 =
                                                                        value,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                      .only(
                                                                  top: MarginValue
                                                                      .medium,
                                                                  bottom:
                                                                      MarginValue
                                                                          .medium),
                                                              child:
                                                                  TextFormField(
                                                                obscureText:
                                                                    true,
                                                                decoration: textInputDecoration
                                                                    .copyWith(
                                                                        labelText:
                                                                            "Nhập lại mật khẩu",
                                                                        prefixIcon:
                                                                            const Icon(
                                                                          Icons
                                                                              .lock,
                                                                          color:
                                                                              Constants.textColor,
                                                                        )),
                                                                onChanged: (value) =>
                                                                    _password2 =
                                                                        value,
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_password1 ==
                                                                    _password2) {
                                                                  if (_password1
                                                                          .length <
                                                                      6) {
                                                                    showSnackbar(
                                                                        context,
                                                                        Colors
                                                                            .red,
                                                                        "Mật khẩu phải hơn 6 ký tự Vui lòng nhập lại");
                                                                  } else {
                                                                    showProcessWaiting(
                                                                        context);
                                                                    final Map<
                                                                            String,
                                                                            dynamic>
                                                                        requestData =
                                                                        {
                                                                      "RequestAction":
                                                                          "ChangePassword",
                                                                      "Params":
                                                                          {
                                                                        "new_password":
                                                                            _password1,
                                                                        "employeeId": userProvider
                                                                            .user!
                                                                            .id,
                                                                      },
                                                                    };
                                                                    await changePassword(
                                                                            userProvider
                                                                                .user!.token,
                                                                            requestData)
                                                                        .then((value) async =>
                                                                            {
                                                                              if (value == "1")
                                                                                {
                                                                                  await showSuccessDialog(context, ""),
                                                                                  Navigator.pop(context),
                                                                                }
                                                                            });
                                                                  }
                                                                } else {
                                                                  showSnackbar(
                                                                      context,
                                                                      Colors
                                                                          .red,
                                                                      "Mật khẩu không khớp. Vui lòng nhập lại");
                                                                }
                                                              },
                                                              child: const Text(
                                                                  'Đổi mật khẩu'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0)),
                                                ),
                                                child:
                                                    const Text("Đổi mật khẩu"),
                                              ),
                                            ]),
                                      SizedBox(
                                        height: desiredHeight * 0.03,
                                      ),
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
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                disabledBackgroundColor: Colors.transparent,
                                disabledForegroundColor: Colors.transparent,
                                padding: const EdgeInsets.all(0),
                              ),
                              child: userProvider.user!.avatar != ""
                                  ? Image.network(
                                      "http://api.cloudpro.vn${userProvider.user!.avatar}",
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.account_circle,
                                      size: 100,
                                      color: Colors.grey[700],
                                    )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget textForm(String? initValue, String? hintText, String? labelText,
      [bool isReadOnly = true,
      Widget? suffixIcon,
      TextEditingController? controller,
      int? maxLines,
      void Function(String)? callBackOnChanged,
      void Function()? callBackOnTap]) {
    return TextFormField(
      readOnly: isReadOnly,
      controller: controller,
      initialValue: initValue,
      maxLines: maxLines,
      onChanged: callBackOnChanged,
      onTap: callBackOnTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText của bạn';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
            vertical: MarginValue.small, horizontal: MarginValue.small),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
            fontFamily: 'roboto',
            fontSize: FontSize.small,
            fontWeight: FontWeight.w300),
        label: Text(
          labelText ?? "",
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'roboto',
              fontSize: FontSize.small,
              fontWeight: FontWeight.w300),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1)),
      ),
      style: const TextStyle(
          color: Constants.textColor,
          fontFamily: 'roboto',
          fontSize: FontSize.small,
          fontWeight: FontWeight.normal),
    );
  }

  static void showSuccessLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          nextScreenRemove(context, const LoginPage());
        });

        return Scaffold(
          body: Center(child: Lottie.asset("assets/goodbye.json")),
        );
      },
    );
  }

  Future showSuccessDialog(BuildContext context, String text2) async {
    String imageAssets = "";
    String text = "Đã thay đổi thành công";

    imageAssets = "assets/success.json";

    Color color = Colors.red;
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(imageAssets, animate: true),
              Text(
                text,
                style: TextStyle(fontSize: FontSize.veryLarge, color: color),
                textAlign: TextAlign.center,
              ),
              Text(
                text2,
                style: TextStyle(fontSize: FontSize.large, color: color),
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      },
    );
  }

  Future showErrorDialog(BuildContext context, String text, String text2,
      {bool route = false}) async {
    String imageAssets = "";
    imageAssets = "assets/error.json";

    Color color = Colors.red;
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      if (route) {
        Navigator.pop(context);
      }
    });
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(imageAssets, animate: true),
              Text(
                text,
                style: TextStyle(fontSize: FontSize.veryLarge, color: color),
                textAlign: TextAlign.center,
              ),
              Text(
                text2,
                style: TextStyle(fontSize: FontSize.large, color: color),
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      },
    );
  }
}
