
import 'package:camera/camera.dart';

class CameraHandler {
  CameraHandler._privateConstructor();
  static final CameraHandler instance = CameraHandler._privateConstructor();
  CameraDescription _camera;

  Future<void> load() async {
    if (this._camera == null) {
      final cameras = await availableCameras();
      this._camera = cameras.first;
    }
  }

  CameraDescription getCamera() {
    return this._camera;
  }
}