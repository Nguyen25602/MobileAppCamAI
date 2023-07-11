import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
class FaceDetectorPainter extends CustomPainter {

  FaceDetectorPainter({required this.absoluteImageSize, required this.faces, required this.direction});
  final Size absoluteImageSize;
  final List<Face> faces;
  CameraLensDirection direction;
  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;
    



    for(Face face in faces) {
      final Paint paint;
      if (face.headEulerAngleY! > 10 || face.headEulerAngleY! < -10) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = Colors.red;
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = Colors.green;
    }
      canvas.drawRect(
        Rect.fromLTRB(
          //direction == CameraLensDirection.front ? 
            (absoluteImageSize.width - face.boundingBox.right) * scaleX,// : face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY, 
          //direction == CameraLensDirection.front ? 
            (absoluteImageSize.width - face.boundingBox.left) * scaleX,// : face.boundingBox.right * scaleX, 
          face.boundingBox.bottom * scaleY
        ), 
        paint
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    
    return oldDelegate.absoluteImageSize != absoluteImageSize || oldDelegate.faces != faces;
  }

}