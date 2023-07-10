import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class CheckWiFi extends StatefulWidget {
  const CheckWiFi({super.key});

  @override
  State<CheckWiFi> createState() => _CheckWiFiState();
}

void main() async {
  final info = NetworkInfo();

  // final wifiName = await info.getWifiName(); // "FooNetwork"
  final wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
  final wifiIP = await info.getWifiIP(); // 192.168.1.43
  // final wifiIPv6 =
  //     await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
  // final wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
  // final wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
  // final wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1

  /// Get the IpAddress based on requestType.
  // ignore: avoid_print
  print(wifiIP);
  // ignore: avoid_print
  print(wifiBSSID);
}

class _CheckWiFiState extends State<CheckWiFi> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: main, child: Text("hello")),
      ),
    );
  }
}
