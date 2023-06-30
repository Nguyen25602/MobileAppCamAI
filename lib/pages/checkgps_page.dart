// ignore_for_file: use_build_context_synchronously
//NGUYEN CREATE //
import 'dart:async';
import 'package:cloudgo_mobileapp/widgets/appbar_widget.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CheckGPS extends StatefulWidget {
  const CheckGPS({super.key});

  @override
  State<CheckGPS> createState() => _CheckGPSState();
}

class _CheckGPSState extends State<CheckGPS> {
  GeoCode geoCode = GeoCode();
  bool isExpanded = false;
  bool isChanged = false;
  bool checkDistance = false;
  String address = "";
  final GlobalKey<ScaffoldState> _hello = GlobalKey<ScaffoldState>();
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late int distance;
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    //GPS Điện thoại có bật không
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      //Quyền truy cập của app đến GPS
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSnackbar(context, Colors.red,
              "Vui lòng cấp quyền truy cấp vị trí của ứng dụng");
        } else if (permission == LocationPermission.deniedForever) {
          showSnackbar(context, Colors.red,
              "Vui lòng cấp quyền truy cấp vị trí của ứng dụng");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });
        showSnackbar(context, Colors.red, "Cập nhật vị trí thành công");
        getLocation();
      }
    } else {
      showSnackbar(context, Colors.red, "Dịch vụ GPS không hoạt động");
    }

    setState(() {
      //refresh the UI
    });
  }

  //Lấy vị trí của mình //
  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    // ignore: unused_local_variable
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      long = position.longitude.toString();
      lat = position.latitude.toString();
      setState(() {
        //refresh UI on update
      });
    });
    Address findMe = await geoCode.reverseGeocoding(
        latitude: position.latitude, longitude: position.longitude);
    setState(() {
      address =
          "${findMe.streetNumber.toString()} - ${findMe.streetAddress.toString()} - ${findMe.city.toString()} - ${findMe.countryName.toString()}";
    });
    setState(() {
      //refresh UI on update
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  //Đặt vị trí công ty
  static const CameraPosition _kCloudGo = CameraPosition(
    tilt: 0,
    target: LatLng(10.8441, 106.7137),
    zoom: 17.651926040649414,
    bearing: 0,
  );
  @override
  Widget build(BuildContext context) {
    //Tính khoảng cách
    distance = Geolocator.distanceBetween(_kCloudGo.target.latitude,
            _kCloudGo.target.longitude, position.latitude, position.longitude)
        .toInt();
    //Xử lý logic Distance
    distance > 200 ? checkDistance = false : checkDistance = true;
    //Custom Icon GoogleMap
    return Scaffold(
      key: _hello,
      appBar: AppBarWidget(
        titlebar: 'CHECK-IN GPS',
        scaffoldKey: _hello,
      ),
      body: SlidingUpPanel(
        color: const Color(0XFF465475),
        minHeight: 160,
        maxHeight: 260,
        onPanelSlide: (double slideAmount) {
          setState(() {
            isExpanded = slideAmount > 0.15;
            isChanged = slideAmount > 0.5;
          });
        },
        panelBuilder: (scrollController) =>
            _buildSlidingPanel(scrollController, context),
        body: SingleChildScrollView(
          child: Container(
            height: 600,
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kCloudGo,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('cloudgo'),
                        position: _kCloudGo.target,
                        infoWindow: const InfoWindow(title: 'Vị trí Công Ty'),
                      ),
                      Marker(
                        markerId: const MarkerId('me'),
                        position: LatLng(position.latitude, position.longitude),
                        infoWindow: const InfoWindow(title: 'Me'),
                      ),
                    },
                    zoomControlsEnabled: false,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                // TEXT //
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  child: const Text(
                    "Vị trí hiện tại :",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Roboto"),
                  ),
                ),
                // ADDRESS //
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: address.isEmpty
                      ? const Text(
                          "GPS không hoạt động vui lòng kiểm tra.",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Roboto"),
                        )
                      : Text(
                          address,
                          style: const TextStyle(
                              color: Colors.white, fontFamily: "Roboto"),
                        ),
                ),
                //Column(children: [
                //Kiểm Tra App bật không
                // Text(servicestatus ? "GPS is Enabled" : "GPS is disabled."),
                //Quyền truy cập của App
                // Text(haspermission ? "GPS is Enabled" : "GPS is disabled."),
                // Vị trí GPS của bạn
                // Text("Longitude: $long", style: const TextStyle(fontSize: 20)),
                // Text(
                //   "Latitude: $lat",
                //   style: const TextStyle(fontSize: 20),
                // ),
                // tên đường + thành phố
                //Container(
                //color: Theme.of(context).primaryColor,
                //),
                //])
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Khoảng cách :",
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          //Tính khoảng cách
                          "$distance meters",
                          style: const TextStyle(
                            color: Colors.yellow,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Đặt padding của button là 0
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Đặt bo góc cho button
                        ),
                        disabledBackgroundColor: const Color(0XFF465475),
                        disabledForegroundColor: Colors.white,
                      ),
                      child: checkDistance
                          ? const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    'Đủ điều kiện',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    'Khoảng cách lớn',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: FaIcon(
                                    FontAwesomeIcons.xmark,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
      //Button gốc thao tác
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
      drawer: AppBarWidget.buildDrawer(context),
    );
  }

  Widget _buildSlidingPanel(
      ScrollController scrollController, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          isChanged
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.expand_more,
                      size: 32,
                      color: Color.fromARGB(199, 172, 176, 184),
                    ),
                  ],
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.expand_less,
                      size: 20,
                      color: Color.fromARGB(199, 172, 176, 184),
                    ),
                  ],
                ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chức năng chính',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                Icon(
                  Icons.help,
                  size: 24,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Tạo button
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconWidgets(
                      iconPath: FaIcon(FontAwesomeIcons.bell),
                      text: 'Thông báo',
                      onPressed: demo,
                      isText: true,
                    ),
                  ],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconWidgets(
                      iconPath: FaIcon(FontAwesomeIcons.camera),
                      text: 'Check-in AI',
                      onPressed: demo,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconWidgets(
                      iconPath: const FaIcon(FontAwesomeIcons.locationDot),
                      text: 'Check-in GPS',
                      onPressed: () {},
                      enable: true,
                    ),
                  ],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconWidgets(
                      iconPath: FaIcon(FontAwesomeIcons.pen),
                      text: 'ĐK nghỉ phép',
                      onPressed: demo,
                      vcolor: Color(0xffF9CA54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //Button
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconWidgets(
                          iconPath: FaIcon(FontAwesomeIcons.wifi),
                          text: 'Check-in WiFi',
                          onPressed: demo,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconWidgets(
                          iconPath: FaIcon(FontAwesomeIcons.fileLines),
                          text: 'Log Check-in',
                          onPressed: demo,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconWidgets(
                          iconPath: FaIcon(FontAwesomeIcons.calendar),
                          text: 'Lịch làm việc',
                          onPressed: demo,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconWidgets(
                          iconPath: FaIcon(FontAwesomeIcons.cableCar),
                          text: 'Xét duyệt NV',
                          onPressed: demo,
                          vcolor: Color(0xff00FFC2),
                          isText: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
        ],
      ),
    );
  }
}

void demo() {}
