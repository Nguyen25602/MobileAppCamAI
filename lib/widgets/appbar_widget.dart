import 'package:cloudgo_mobileapp/helper/helper_function.dart';
import 'package:cloudgo_mobileapp/main.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/pages/information_page.dart';
import 'package:cloudgo_mobileapp/pages/login_page.dart';
import 'package:cloudgo_mobileapp/pages/request_page.dart';
import 'package:cloudgo_mobileapp/pages/timekeeping_history_page.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/repository/NotificationRepository.dart';
import 'package:cloudgo_mobileapp/repository/RequestRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String titlebar;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User? user;
  const AppBarWidget({
    required this.user,
    required this.titlebar,
    required this.scaffoldKey,
    Key? key,
  }) : super(key: key);

  static Drawer buildDrawer(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          user?.avatar == ""
              ? Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey[700],
                )
              : Container(
                  height: 150,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          "http://192.168.31.33/onlinecrm${user?.avatar}"), // Đặt URL hình ảnh của bạn ở đây
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          const SizedBox(
            height: 15,
          ),
          Consumer<UserProvider>(
            builder: (context, value, _) => Text(
              value.user!.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          // Tab Group
          ListTile(
            onTap: () {
              nextScreen(context, const InformationPage());
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.group,
              color: Constants.textColor,
            ),
            title: const Text(
              "Hồ sơ cá nhân",
              style: TextStyle(color: Constants.textColor),
            ),
          ),
          // Tab
          ListTile(
            onTap: () {
              nextScreen(context, const RequestPage());
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading:
                const Icon(Icons.pending_actions, color: Constants.textColor),
            title: const Text(
              "Đăng ký nghĩ phép",
              style: TextStyle(color: Constants.textColor),
            ),
          ),
          ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading:
                const Icon(Icons.settings_outlined, color: Constants.textColor),
            title: const Text(
              "Cài đặt",
              style: TextStyle(color: Constants.textColor),
            ),
          ),
          ListTile(
            onTap: () {
              nextScreen(context, const TimekeepingHistoryPage());
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.access_time_outlined,
                color: Constants.textColor),
            title: const Text(
              "Xem lịch sử chấm công",
              style: TextStyle(color: Constants.textColor),
            ),
          ),
          // Tab Logout
          ListTile(
            onTap: () async {
              return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Đăng Xuất",
                          style: TextStyle(color: Constants.textColor)),
                      content: const Text("Bạn Muốn Đăng Xuất ?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            logoutEmployee(user!.token).then((value) async => {
                                  await HelperFunctions.saveUserLoggedInStatus(
                                      false),
                                  await HelperFunctions.saveAccessTokenSF(""),
                                  await HelperFunctions.saveUserNameSF(""),
                                  await HelperFunctions.saveEmployeeIdSF(""),
                                  context.read<UserProvider>().clear(),
                                  context.read<RequestRepository>().clear(),
                                  context.read<CheckinRepository>().clear(),
                                  context
                                      .read<NotificationRepository>()
                                      .clear(),
                                  isSigned = false,
                                  if (value != null)
                                    {
                                      if (value["success"] == "1")
                                        {
                                          showSnackbar(context, Colors.red,
                                              "Đăng xuất thành công"),
                                          nextScreenRemove(
                                              context, const LoginPage())
                                        }
                                      else
                                        {
                                          showSnackbar(context, Colors.blue,
                                              "Đăng xuất thất bại"),
                                          Navigator.pop(context),
                                        }
                                    }
                                  else
                                    {
                                      showSnackbar(context, Colors.red,
                                          "Đã có thiết bị khác đăng nhập !!!"),
                                      nextScreenRemove(
                                          context, const LoginPage())
                                    }
                                });
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app, color: Constants.textColor),
            title: const Text(
              "Đăng Xuất",
              style: TextStyle(color: Constants.textColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: const SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Image(image: AssetImage("assets/Logo_CloudGo.png")),
                Icon(Icons.close),
              ],
            ),
          ),
          content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Button 1'),
                  onPressed: () {
                    // Hành động khi nhấn Button 1
                  },
                ),
                ElevatedButton(
                  child: const Text('Button 2'),
                  onPressed: () {
                    // Hành động khi nhấn Button 2
                  },
                ),
                ElevatedButton(
                  child: const Text('Button 3'),
                  onPressed: () {
                    // Hành động khi nhấn Button 3
                  },
                ),
              ]),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 3, // Chiều cao của đường thẳng
            width: double.infinity, // Đặt độ rộng thành vô hạn
            color: Constants.lineColor, // Màu sắc của đường thẳng
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.titlebar,
          style: GoogleFonts.robotoCondensed(
            color: Constants.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            widget.scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: widget.user?.avatar == ""
                  ? Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.grey[700],
                    )
                  : Image.network(
                      "http://192.168.31.33/onlinecrm${widget.user?.avatar}",
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
