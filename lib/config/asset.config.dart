import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AssetConfig {
  AssetConfig._privateConstructor();
  static final AssetConfig instance = AssetConfig._privateConstructor();
  String testImagePath;

  final Map<String, AssetImage> _contents = {
    'onboarding': AssetImage('assets/images/onboarding.png'),
    'icon': AssetImage('assets/images/icon.png'),
    'noData': AssetImage('assets/images/Doctor-amico.png'),
    'noDataPatient': AssetImage('assets/images/Doctor-pana.png'),
    'oneState': AssetImage('assets/images/img-1.png'),
    'twoState': AssetImage('assets/images/img-2.gif'),
    'threeState': AssetImage('assets/images/img-3.gif'),
    'fourState': AssetImage('assets/images/img-4.png'),
    'walkOne': AssetImage('assets/images/walk_1.png'),
    'walkTwo': AssetImage('assets/images/walk_2.png'),
  };

  AssetImage get(String name) => this._contents[name];

  Future<String> getTestImagePath() async {
    if (this.testImagePath == null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = join(directory.path, 'image_test.png');

      ByteData data = await rootBundle.load(env['IMAGE_TEST']);
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      File file = File(path);
      await file.writeAsBytes(bytes);
      this.testImagePath = file.path;
    }

    return this.testImagePath;
  }
}
