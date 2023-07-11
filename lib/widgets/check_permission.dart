
import 'package:cloudgo_mobileapp/pages/checkcamera_page.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
class CheckPermissionPage extends StatefulWidget {
  const CheckPermissionPage({super.key,required this.permission });
  final Permission permission;

  @override
  State<CheckPermissionPage> createState() => _CheckPermissionPageState();
}



class _CheckPermissionPageState extends State<CheckPermissionPage> {
  bool _isGranted = false;
  _grantedPermission() async {
    if(await widget.permission.request().isDenied) {
      showSnackbar(context, Colors.red[400], "Vui lòng cấp quyền để có thể thực hiện tiếp ");
    }else {
      nextScreen(context, const CheckInCameraPage());
    }
  }

  @override
  void initState() {
    _grantedPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(_isGranted) {
      
    }else {
      //showSnackbar(context, Colors.red[400], "Vui lòng cấp quyền để có thể thực hiện tiếp ");
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}