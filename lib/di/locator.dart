import 'package:cloudgo_mobileapp/service/face_detector_service.dart';
import 'package:cloudgo_mobileapp/service/face_recognition_service.dart';
import 'package:get_it/get_it.dart';
import 'package:cloudgo_mobileapp/service/camera_service.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FaceDetectorService>((){
    final _cameraService = locator<CameraService>();
    return FaceDetectorService(service: _cameraService);
  });

  locator.registerLazySingleton<MlService>(() => MlService(),);
}
