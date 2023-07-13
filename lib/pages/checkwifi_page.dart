import 'package:flutter/material.dart';

class CheckWiFi extends StatefulWidget {
  const CheckWiFi({super.key});

  @override
  State<CheckWiFi> createState() => _CheckWiFiState();
}

class Wifi {
  final String _name;
  final String _ip;

  Wifi(this._name, this._ip);
}

List<Wifi> items = [
  Wifi("Lưỡng Huyền", "192.0.0.10"),
  Wifi("CRMONLINE_G", "192.0.1.1"),
  Wifi("CRMONLINE_1", "192.0.0.1"),
  Wifi("CRMONLINE_2", "192.0.0.2"),
  Wifi("CRMONLINE_3", "192.0.0.3"),
  Wifi("CRMONLINE_4", "192.0.0.4"),
  Wifi("CRMONLINE_FAKE", "192.0.0.5"),
  Wifi("Sự Nguyễn", "192.0.0.6"),
  Wifi("Honkai Star Rail", "192.0.0.7"),
  Wifi("Genshin Impact", "192.0.0.8"),
  Wifi("LOL", "192.0.0.9"),
  Wifi("VALORANT", "192.0.0.11"),
  Wifi("Left 4 dead 2", "192.0.0.12"),
  Wifi("VINA_MILK", "192.0.0.13"),
  Wifi("Wifi yếu xin đừng vào", "192.0.0.14"),
  Wifi("Wifi mạnh nhưng không share", "192.0.0.15"),
];

class _CheckWiFiState extends State<CheckWiFi> {
  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  bool correct = false;
  int iselectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'Logo_CloudGo.png',
            width: 200,
            height: 50,
            fit: BoxFit.contain,
            alignment: Alignment(5, 5),
          ),
          Container(
            child: ElevatedButton(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 50),
            child: Text(
              'Mạng đang kết nối',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('${iselectedIndex}');
                      },
                      icon: Icon(Icons.wifi),
                      label: Text('${items[iselectedIndex]._name}'),
                      style: ElevatedButton.styleFrom(
                        side: null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  color: Color(0xFF35BF8E),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('Icon_Wifi.png'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Thông tin wifi'),
                          Text('Tên wifi: ${items[iselectedIndex]._name}'),
                          Text('IP: ${items[iselectedIndex]._ip}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 50),
            child: Text(
              'Mạng hiện có',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Container(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++)
                    Container(
                      height: 50,
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Xác nhận'),
                                  content: Text(
                                      'Bạn có muốn kết nối với ${items[i]._name} không?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Hành động khi nhấn nút Đồng ý
                                        setState(() {
                                          iselectedIndex =
                                              i; // Cập nhật chỉ mục nút được chọn
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Đồng ý'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Hành động khi nhấn nút Hủy bỏ
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Hủy bỏ'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.wifi),
                          label: Text('${items[i]._name}'),
                          style: ElevatedButton.styleFrom(
                            side: null,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          CheckIPCorrect(correct),
          Center(
            child: Container(
              width: 330,
              height: 60,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Hành động khi nút 1 được nhấn
                    print('Checkin Wifi đã được nhấn');
                    setState(() {
                      correct = !correct;
                    });
                  },
                  child: Text('Check in Wifi', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CheckIPCorrect(bool _check) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _check ? Colors.lightGreen : Colors.red,
        ),
        width: 200,
        height: 30,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_check ? 'Checkin thành công' : 'Checkin thất bại'),
          Icon(
            Icons.check_box,
          ),
        ]),
      ),
    );
  }

  Widget ButtonWifi(String _name, int i) {
    return Container(
      height: 50,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: ElevatedButton.icon(
          onPressed: () {
            print('Nút ${i} đã được bấm');
            setState() {
              iselectedIndex = i;
            }
          },
          icon: Icon(Icons.wifi),
          label: Text(_name),
          style: ElevatedButton.styleFrom(
            side: null,
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
    );
  }
}

void demo() {}
