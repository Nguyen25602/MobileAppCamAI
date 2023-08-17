import 'dart:async';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class CheckInWifi extends StatefulWidget {
  const CheckInWifi({Key? key}) : super(key: key);

  @override
  State<CheckInWifi> createState() => _CheckInWifiState();
}

void getInfoWiFi() async {
  final info = NetworkInfo();
  final wifiName = await info.getWifiName(); // "FooNetwork"
  final wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
  final wifiIP = await info.getWifiIP(); // 192.168.1.43
  // final wifiIPv6 =
  //     await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
  // final wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
  // final wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
  // final wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1
  /// Get the IpAddress based on requestType.
  // ignore: avoid_print
  print(wifiName);
  print(wifiIP);
  // ignore: avoid_print
  print(wifiBSSID);
}

class _CheckInWifiState extends State<CheckInWifi> {
  String _wifiName = '';
  String _wifiIp = '';
  bool correct = false;

  @override
  void initState() {
    super.initState();
    _checkConnect();
  }

  Future<void> _checkConnect() async {
    final info = NetworkInfo();
    final wifiName = await info.getWifiName();
    final wifiIp = await info.getWifiIP();

    setState(() {
      _wifiName = wifiName ?? '';
      _wifiIp = wifiIp ?? '';
    });
  }

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Tên wifi:'),
                        SizedBox(height: 20),
                        Text('IP:'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_wifiName),
                        const SizedBox(height: 20),
                        Text(_wifiIp),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    checkIp();
                  },
                  child: const Text('Check - In'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //Thay ở đây
            dialogBuilder(context);
          },
          child: const Text('Wifi'),
        ),
      ),
    );
  }

  checkIp() {
    if (_wifiIp != '192.168.31.28') {
      removeCurrentSnackBar(context);
      showSnackbar(
          context, Colors.red, "IP không đúng. Vui lòng thay đổi wifi");
    } else {
      removeCurrentSnackBar(context);
      showSnackbar(context, Colors.lightGreen, "Check-In thành công");
    }
    Navigator.pop(context);
  }
}
