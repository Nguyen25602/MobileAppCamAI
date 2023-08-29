// ignore_for_file: use_build_context_synchronously
//NGUYEN CREATE //
import 'dart:async';
import 'dart:io';
import 'package:cloudgo_mobileapp/object/CheckIn.dart';
import 'package:cloudgo_mobileapp/object/TimeKeeping.dart';
import 'package:cloudgo_mobileapp/object/User.dart';
import 'package:cloudgo_mobileapp/repository/CheckinRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:cloudgo_mobileapp/widgets/appbar_widget.dart';
import 'package:cloudgo_mobileapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart' as animation;
import 'package:provider/provider.dart';

class CheckGPS extends StatefulWidget {
  const CheckGPS({super.key});

  @override
  State<CheckGPS> createState() => _CheckGPSState();
}

class _CheckGPSState extends State<CheckGPS> {
  // Config Camera by Hoang Nguyen
  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print(_image);
      print("gdsfdsfdsfdsf");
      print(pickedFile.path);
      await _showImageDialog();
    }
  }

  // Config GPS by Hoang Nguyen
  String _address = "";
  bool checkDistance = false;
  String timeNow = "";
  final GlobalKey<ScaffoldState> _hello = GlobalKey<ScaffoldState>();
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  late int distance;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    super.dispose();
    // positionStream.cancel();
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
          // showSnackbar(context, Colors.red,
          //     "Vui lòng cấp quyền truy cấp vị trí của ứng dụng");
        } else if (permission == LocationPermission.deniedForever) {
          // showSnackbar(context, Colors.red,
          //     "Vui lòng cấp quyền truy cấp vị trí của ứng dụng");
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
        // showSnackbar(context, Colors.red, "Cập nhật vị trí thành công");
      }
    } else {
      // showSnackbar(context, Colors.red, "Dịch vụ GPS không hoạt động");
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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark firstPlace = placemarks.first;
      setState(() {
        _address =
            "${firstPlace.street}, ${firstPlace.locality}, ${firstPlace.country}";
      });
      print(_address);
    }
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
    if (servicestatus == false) {
      return Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                animation.Lottie.asset("assets/gpsStatus.json"),
                SizedBox(height: 20),
                Text(
                  "Để xử dụng tính năng này",
                  style: TextStyle(
                    color: Constants.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Vui lòng bật GPS",
                  style: TextStyle(
                    color: Constants.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    double height = MediaQuery.of(context).size.height;
    var userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
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
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              disabledBackgroundColor:
                                  Constants.successfulColor),
                          child: const Text(
                            'GPS ON',
                            style: TextStyle(
                                color: Constants.whiteTextColor,
                                fontSize: FontSize.verySmall,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              disabledBackgroundColor:
                                  Constants.dangerousColor),
                          child: const Text(
                            'GPS OFF',
                            style: TextStyle(
                                color: Constants.whiteTextColor,
                                fontSize: FontSize.verySmall,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  haspermission
                      ? ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              disabledBackgroundColor:
                                  Constants.successfulColor),
                          child: const Text(
                            'ACCESS ON',
                            style: TextStyle(
                                color: Constants.whiteTextColor,
                                fontSize: FontSize.verySmall,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              disabledBackgroundColor:
                                  Constants.dangerousColor),
                          child: const Text(
                            'ACCESS OFF',
                            style: TextStyle(
                                color: Constants.whiteTextColor,
                                fontSize: FontSize.verySmall,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
              // Map //
              SizedBox(
                height: height / 2.5,
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
                child: const Text(
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
                child: _address == ""
                    ? const Text(
                        "GPS không hoạt động vui lòng kiểm tra.",
                        style: TextStyle(
                            color: Constants.textColor,
                            fontFamily: "Roboto",
                            fontSize: 12),
                      )
                    : Text(
                        _address,
                        style: const TextStyle(
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
                      const Text(
                        "Khoảng cách :",
                        style: TextStyle(
                            color: Constants.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      servicestatus == true
                          ? Text(
                              //Tính khoảng cách
                              "$distance meters",
                              style: const TextStyle(
                                color: Constants.textColor,
                                fontSize: 12,
                              ),
                            )
                          : const Text(
                              //Tính khoảng cách
                              "None",
                              style: TextStyle(
                                color: Constants.textColor,
                                fontSize: 12,
                              ),
                            )
                    ],
                  ),
                  if (servicestatus)
                    const SizedBox(
                      width: 20,
                    ),
                  if (servicestatus)
                    ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Đặt padding của button là 0
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Đặt bo góc cho button
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
                      onPressed: () async {
                        final checkIn = CheckIn(
                            date: DateTime.now(), device: TypeDevice.gps);

                        final data = checkIn.toMap();
                        data["distance"] = distance.toString();
                        data["place_name"] = _address;
                        String result = await context
                            .read<CheckinRepository>()
                            .checkIn(data);
                        checkinStatusDialog(context, result, "GPS");
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
                      onPressed: () => _getImage(ImageSource.camera),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: AppBarWidget.buildDrawer(context),
    );
  }

  Future<void> _showImageDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selected Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(_image!),
              SizedBox(height: 20),
              Text('Do you want to submit this image?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: animation.Lottie.asset('assets/cancle.json', height: 60),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: animation.Lottie.asset('assets/send.json', height: 60),
              onPressed: () {
                // Perform submission logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
