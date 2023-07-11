import 'package:camera/camera.dart';
import 'package:cloudgo_mobileapp/widgets/face_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/service/face_detector_service.dart';
import 'package:cloudgo_mobileapp/service/camera_service.dart';

class CameraDetectionPreview extends StatefulWidget {
  const CameraDetectionPreview({super.key,required this.cameraService, required this.faceDetectorService});
  final CameraService cameraService;
  final FaceDetectorService faceDetectorService;
  @override
  State<CameraDetectionPreview> createState() => _CameraDetectionPreviewState();

}

class _CameraDetectionPreviewState extends State<CameraDetectionPreview> {


  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final Size imageSize = Size(widget.cameraService.cameraController!.value.previewSize!.height,  widget.cameraService.cameraController!.value.previewSize!.width);
    return 
             Transform.scale(
              scale: 1.0,
              child: AspectRatio(
                aspectRatio: MediaQuery.of(context).size.aspectRatio,
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child:Container(
                      width: width,
                      height:  width * widget.cameraService.cameraController!.value.aspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview( widget.cameraService.cameraController!),
                          if(widget.faceDetectorService.faceDetected) 
                            CustomPaint(
                              painter: FaceDetectorPainter(
                                absoluteImageSize: imageSize, 
                                faces: widget.faceDetectorService.faces, 
                                direction: widget.cameraService.cameraLensDirection),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );  
        
      
  }

  @override
  void dispose() {
    widget.cameraService.dispose();
    super.dispose();
  }
}