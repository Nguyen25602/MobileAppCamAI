// ignore_for_file: use_build_context_synchronously
//NGUYEN CREATE //
import 'dart:async';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/pages/home_page.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/appbar_widget.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CheckGPS extends StatefulWidget {
  const CheckGPS({super.key});

  @override
  State<CheckGPS> createState() => _CheckGPSState();
}

class _CheckGPSState extends State<CheckGPS> {
  bool _isCheckIn = false;
  GeoCode geoCode = GeoCode();
  bool isExpanded = false;
  bool isChanged = false;
  bool checkDistance = false;
  String address = "";
  String timeNow = "";
  final GlobalKey<ScaffoldState> _hello = GlobalKey<ScaffoldState>();
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  late int distance;
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    checkGps();
    position = const Position(
        longitude: 0,
        latitude: 0,
        timestamp: null,
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);
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
        getLocation();
        showSnackbar(context, Colors.red, "Cập nhật vị trí thành công");
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
    //Lấy vị trí 1 lần
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Lấy vị trí liên tục
    // LocationSettings locationSettings = const LocationSettings(
    //   accuracy: LocationAccuracy.high, //accuracy of the location data
    //   distanceFilter: 100, //minimum distance (measured in meters) a
    //   //device must move horizontally before an update event is generated;
    // );

    // // ignore: unused_local_variable
    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position position) {
    //   setState(() {});
    // });

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
    var userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user;
    distance = Geolocator.distanceBetween(_kCloudGo.target.latitude,
            _kCloudGo.target.longitude, position.latitude, position.longitude)
        .toInt(); //Tính khoảng cách
    distance > 200
        ? checkDistance = false
        : checkDistance = true; //Xử lý logic Distance
    return Scaffold(
      key: _hello,
      appBar: AppBarWidget(
        titlebar: 'CHECK-IN GPS',
        scaffoldKey: _hello,
        user: user,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  servicestatus
                      ? ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              disabledBackgroundColor:
                                  Constants.successfulColor),
                          child: Text(
                            'GPS ON',
                            style: TextStyle(
                                color: Constants.whiteTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              disabledBackgroundColor:
                                  Constants.dangerousColor),
                          child: Text(
                            'GPS OFF',
                            style: TextStyle(
                                color: Constants.whiteTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  haspermission
                      ? ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              disabledBackgroundColor:
                                  Constants.successfulColor),
                          child: Text(
                            'ACCESS ON',
                            style: TextStyle(
                                color: Constants.whiteTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              disabledBackgroundColor:
                                  Constants.dangerousColor),
                          child: Text(
                            'ACCESS OFF',
                            style: TextStyle(
                                color: Constants.whiteTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
              // Map //
              SizedBox(
                height: 350,
                child: GoogleMap(
                  trafficEnabled: true,
                  myLocationEnabled: true,
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
                child: Text(
                  "Vị trí hiện tại :",
                  style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: "Roboto"),
                ),
              ),
              // ADDRESS //
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: address.isEmpty
                    ? Text(
                        "GPS không hoạt động vui lòng kiểm tra.",
                        style: TextStyle(
                            color: Constants.textColor,
                            fontFamily: "Roboto",
                            fontSize: 12),
                      )
                    : Text(
                        address,
                        style: TextStyle(
                            color: Constants.textColor,
                            fontFamily: "Roboto",
                            fontSize: 12),
                      ),
              ),
              // Distance //
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Khoảng cách :",
                        style: TextStyle(
                            color: Constants.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        //Tính khoảng cách
                        "$distance meters",
                        style: TextStyle(
                          color: Constants.textColor,
                          fontSize: 12,
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
                        borderRadius:
                            BorderRadius.circular(20), // Đặt bo góc cho button
                      ),
                      disabledBackgroundColor: Constants.enableButton,
                      disabledForegroundColor: Colors.white,
                    ),
                    child: checkDistance
                        ? const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Đủ điều kiện',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.check,
                                  color: Colors.yellow,
                                  size: 14,
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.xmark,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                  )
                ]),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isCheckIn = true;
                          DateTime now = DateTime.now();
                          var formatterTime = DateFormat('kk:mm');
                          timeNow = formatterTime.format(now);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(
                            10, 15, 10, 15), // Đặt padding của button là 0
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Đặt bo góc cho button
                        ),
                        backgroundColor: Constants.enableButton,
                      ),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'CHECK-IN',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: FaIcon(
                              FontAwesomeIcons.mapLocation,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(
                            15), // Đặt padding của button là 0
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Đặt bo góc cho button
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: FaIcon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(
                            15), // Đặt padding của button là 0
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Đặt bo góc cho button
                        ),
                        backgroundColor: Constants.enableButton,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: FaIcon(
                          FontAwesomeIcons.locationArrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isCheckIn)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Đã Check - In thành công vào lúc $timeNow",
                      style: TextStyle(
                          color: Constants.textColor,
                          fontFamily: "Roboto",
                          fontSize: 14),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
      drawer: AppBarWidget.buildDrawer(context),
    );
  }
}

void demo() {}
