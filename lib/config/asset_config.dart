import 'package:flutter/material.dart';

class AssetConfig {
  AssetConfig._privateConstructor();
  static final AssetConfig instance = AssetConfig._privateConstructor();

  final Map<String, AssetImage> _contents = {
    'onboarding': AssetImage('assets/images/onboarding.png'),
    'icon': AssetImage('assets/images/icon.png'),
    'noData': AssetImage('assets/images/Doctor-amico.png'),
    'noDataPatient': AssetImage('assets/images/Doctor-pana.png'),
    'oneState': AssetImage('assets/images/img-1.png'),
    'twoState': AssetImage('assets/images/img-2.gif'),
    'threeState': AssetImage('assets/images/img-3.gif'),
    'fourState': AssetImage('assets/images/img-4.png'),
  };

  AssetImage get(String name) => this._contents[name];
}
