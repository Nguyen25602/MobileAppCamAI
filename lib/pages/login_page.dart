import 'package:cloudgo_mobileapp/helper/helper_function.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/pages/main_page.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
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
                    margin: const EdgeInsets.only(top: MarginValue.medium),
                    child: const Text(
                      "CloudGO xin chào",
                      style: TextStyle(
                          color: Constants.textColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: MarginValue.medium),
                    child: const Text(
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
                    margin: const EdgeInsets.only(top: MarginValue.exxxLarge),
                    child: const Text(
                      "Tài khoản",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: MarginValue.medium),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: "Nhập Email Của Bạn",
                          labelStyle: const TextStyle(fontSize: 12),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Constants.textColor,
                          )),
                      onChanged: (value) => email = value,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: MarginValue.medium),
                    child: const Text(
                      "Mật khẩu",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: MarginValue.medium, bottom: MarginValue.medium),
                    child: TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          labelText: "Nhập Mật Khẩu",
                          prefixIcon: const Icon(
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
                            login(provider, context);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Constants.enableButton),
                          child: Container(
                            padding: const EdgeInsets.all(MarginValue.medium),
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
                          margin: const EdgeInsets.symmetric(
                              vertical: MarginValue.small),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
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

  Future updateRepository(BuildContext context, String token, String name,
      String employeeId) async {
    await context
        .read<CheckinRepository>()
        .updateUserInformation(token, employeeId);
    await context
        .read<RequestRepository>()
        .updateUserInformation(token, name, employeeId);
  }

  login(UserProvider provider, BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (email.contains("@")) {
        loginGmailEmployee(email, password).then((response) {
          if (response != null) {
            User user = User.fromMap(response);
            provider.updateUserStart(user);
            HelperFunctions.saveUserLoggedInStatus(true);
            HelperFunctions.saveAccessTokenSF(user.token);
            HelperFunctions.saveUserNameSF(user.userName);
            HelperFunctions.saveEmployeeIdSF(user.id);
            updateRepository(context, user.token, user.name, user.id)
                .then((value) => nextScreenReplace(
                      context,
                      const MainPage(),
                    ));
          } else {
            // Handle the error here
            showSnackbar(context, Colors.red,
                "Gmail hoặc Password không đăng nhập được!!");
          }
        });
      } else {
        loginUsernameEmployee(email, password).then((response) {
          if (response != null) {
            User user = User.fromMap(response);
            provider.updateUserStart(user);
            HelperFunctions.saveUserLoggedInStatus(true);
            HelperFunctions.saveAccessTokenSF(user.token);
            HelperFunctions.saveUserNameSF(user.userName);
            HelperFunctions.saveEmployeeIdSF(user.id);
            updateRepository(context, user.token, user.name, user.id)
                .then((value) => nextScreenReplace(
                      context,
                      const MainPage(),
                    ));
          } else {
            // Handle the error here
            showSnackbar(context, Colors.red,
                "Username hoặc Password không đăng nhập được!!");
          }
        });
      }
    }
  }
}
