import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/customized/customized.dart';

class InsideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationName,
      theme: ThemeData(
        fontFamily: defaultFont
      ),
      debugShowCheckedModeBanner: false,
      home: PbScaffold(
        child: Text('oi'),
      ),
    );
  }

}