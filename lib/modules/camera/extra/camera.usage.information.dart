import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';

class CameraUsageInformation extends StatefulWidget {
  final List cardList = [
    BoxStage(
        text: 'Primeiramente, posicione o paciente.',
        image: AppConfig.instance.assetConfig.get('oneState')),
    BoxStage(
        text: 'Agora, aponte o celular verticalmente em direção ao paciente.',
        image: AppConfig.instance.assetConfig.get('twoState')),
    BoxStage(
        text: 'Clique no botão e acompanhe o paciente caminhar.',
        image: AppConfig.instance.assetConfig.get('threeState')),
    BoxStage(
      text: 'Estamos em fase de teste, não se preocupe com o resultado.',
      image: AppConfig.instance.assetConfig.get('fourState'),
      width: 100,
    ),
  ];

  @override
  _CameraUsageInformationState createState() => _CameraUsageInformationState();
}

class _CameraUsageInformationState extends State<CameraUsageInformation> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      height: MediaQuery.of(context).size.height * 0.3,
      autoPlayCurve: Curves.fastOutSlowIn,
      aspectRatio: 2.0,
      items: this.widget.cardList.map((card) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: ThemeConfig.primaryColor,
                child: card,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class BoxStage extends StatelessWidget {
  final String text;
  final AssetImage image;
  final double width;

  const BoxStage({Key key, this.text, this.image, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: this.image,
          width: width,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(color: ThemeConfig.ternaryColor),
          ),
        )
      ],
    );
  }
}
