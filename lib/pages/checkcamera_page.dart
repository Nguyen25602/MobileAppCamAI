import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/widgets/camera_detection_preview.dart';
import 'package:cloudgo_mobileapp/widgets/camera_header.dart';
import 'package:cloudgo_mobileapp/di/locator.dart';
import 'package:cloudgo_mobileapp/service/camera_service.dart';
import 'package:cloudgo_mobileapp/service/face_detector_service.dart';
import 'package:cloudgo_mobileapp/service/face_recognition_service.dart';
import 'package:cloudgo_mobileapp/models/user.model.dart';
import 'package:cloudgo_mobileapp/db/databse_helper.dart';
import 'package:logger/logger.dart';
class CheckInCameraPage extends StatefulWidget {
  const CheckInCameraPage({super.key});

  @override
  State<CheckInCameraPage> createState() => _CheckInCameraPageState();
}

class _CheckInCameraPageState extends State<CheckInCameraPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CameraService _cameraService = locator<CameraService>();
  final FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  final MlService _mlService = locator<MlService>();
  bool _isInitializing = false;
  bool _logSuccess = false;
  @override
  void initState() {
    super.initState();
    _start();
    
  }


  Future _start() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    _faceDetectorService.initialize();
    setState(() => _isInitializing = false);
    _frameFaces();
  }
  _frameFaces() async {
    bool processing = false;
    _cameraService.cameraController!.startImageStream((CameraImage image) async {
      if(processing) return;
      processing = true;
      await _checkInCamera(image: image);
      processing = false;

    });
  }
   Future _signUp() async {
    DatabaseHelper _databaseHelper = DatabaseHelper.instance;
    List predictedData = _mlService.predictedData;
    String user = "tuong";
    String password = "123";
    User userToSave = User(
      user: user,
      password: password,
      modelData: predictedData,
    );
    await _databaseHelper.insert(userToSave);
    this._mlService.setPredictedData([]);
    
  }

  _checkInCamera({required CameraImage? image}) async {
    assert(image != null , "Image is null");
    await _faceDetectorService.detectFacesFromImage(image: image!);
    if(_faceDetectorService.faceDetected) {
      Logger().i(_faceDetectorService.faces.length);
      _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);

      
      User? user = await _mlService.predict();
      if(user != null) {
        Logger().e(user.toMap().toString());
        _logSuccess = true;
      }else {
        Logger().e("NULL");
      }

    }
     if (mounted) setState(() {});
  }


  @override
  void dispose() {
    _cameraService.dispose();
    _mlService.dispose();
    _faceDetectorService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    Widget body = bodyWidget();
    Widget header = CameraHeader("", onBackPressed: _onBackPressed);
    return  Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [body,header,if( _logSuccess == true ) logSuccess()]
      )
    );
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }
  Widget bodyWidget() {
    if(_isInitializing) {
      return isInitializing();
    }else {
      return CameraDetectionPreview(cameraService: _cameraService, faceDetectorService: _faceDetectorService,);
    }
  }
  Widget isInitializing() {
    return const SizedBox(child: Center(child: CircularProgressIndicator()));
  }

  Widget logSuccess() {
    return Opacity(
      opacity: 0.8,
      child: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 159,
                    height: 163.93,
                    decoration:const ShapeDecoration(
                      color: Color(0xFF525F80),
                      shape: OvalBorder(
                        side: BorderSide(width: 1, color: Colors.white),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.check,
                    color: Color(0xFFD9D9D9),
                    size: 103,
                  )
                ],
              ),
            ),
            const Column(
              children: [
                SizedBox(height: 30,),
                Text(
                  'BẠN ĐÃ VÀO CA THÀNH CÔNG',
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.40,
                  ),
                ),
              ],
            ),
          ],
        ),
       
      ),
    );
  }
}

