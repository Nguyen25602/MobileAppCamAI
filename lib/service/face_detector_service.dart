import "package:cloudgo_mobileapp/service/camera_service.dart";
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
class FaceDetectorService {
  FaceDetectorService({required CameraService service}) : _cameraService = service;
  final CameraService _cameraService;

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces;
  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = FaceDetector(options:  FaceDetectorOptions(
      enableClassification: true,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.accurate
    ));
  }

  Uint8List concatenatePlane(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for(Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  InputImageMetadata buildMetadata(CameraImage image, InputImageRotation imagerotation) {
    return InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: imagerotation, 
      format: InputImageFormatValue.fromRawValue(image.format.raw)!,
      bytesPerRow: image.planes.map((Plane plane) => plane.bytesPerRow).first,
      );
  }

  Future<void> detectFacesFromImage({required CameraImage image, }) async {
      _faces = await _faceDetector.processImage(
        InputImage.fromBytes(
          bytes: concatenatePlane(image.planes), 
          metadata: buildMetadata(image, _cameraService.cameraRotation!))
      );
  }

    dispose() {
    _faceDetector.close();
  }

}