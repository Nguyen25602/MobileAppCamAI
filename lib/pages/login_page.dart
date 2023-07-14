import 'package:cloudgo_mobileapp/pages/home_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: MarginValue.large,
              right: MarginValue.large,
              top: MarginValue.small),
          child: Form(
            key: formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 105,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/cloudgo_icon.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MarginValue.medium),
                    child: Text(
                      "Cloudgo xin chào",
                      style: TextStyle(
                          color: Constants.textColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MarginValue.medium),
                    child: Text(
                      "Mời bạn đăng nhập bằng email của bạn",
                      style: TextStyle(
                          color: Constants.textColor,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MarginValue.exxxLarge),
                    child: const Text(
                      "Tài khoản",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MarginValue.medium),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: "Nhập Email Của Bạn",
                          labelStyle: const TextStyle(fontSize: 12),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Constants.textColor,
                            size: 12,
                          )),
                      onChanged: (value) => email = value,
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "Vui lòng nhập đúng email của bạn";
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MarginValue.medium),
                    child: const Text(
                      "Mật khẩu",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MarginValue.medium, bottom: MarginValue.medium),
                    child: TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          labelText: "Nhập Mật Khẩu",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Constants.textColor,
                          )),
                      validator: (val) {
                        if (val!.length < 6) {
                          return "Vui lòng nhập Password không dưới 6 ký tự";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => password = value,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Constants.enableButton),
                          child: Container(
                            padding: EdgeInsets.all(MarginValue.medium),
                            child: const Text(
                              "ĐĂNG NHẬP",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: MarginValue.small),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Quên mật khẩu?",
                              style: TextStyle(
                                color: Constants.enableButton,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  login() {
    if (formKey.currentState!.validate()) {
      if (email == "test@gmail.com" && password == "test123") {
        nextScreenReplace(context, const HomeScreen());
      } else {
        showSnackbar(context, Colors.red, "Không Đăng Nhập Được");
      }
    }
  }
}
