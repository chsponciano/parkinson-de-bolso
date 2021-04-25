import 'package:camera/camera.dart';

class CameraConfig {
  CameraConfig._privateConstructor();
  static final CameraConfig instance = CameraConfig._privateConstructor();
  CameraDescription _camera;

  Future<void> load() async {
    if (this._camera == null) {
      final cameras = await availableCameras();
      this._camera = cameras.first;
    }
  }

  CameraDescription get camera => this._camera;
}
