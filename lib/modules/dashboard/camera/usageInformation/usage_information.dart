import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/constant/assest_path.dart';

class UsageInformation extends StatefulWidget {
  final List cardList = [
    BoxStage(text: 'Primeiramente, posicione o paciente.', image: oneState),
    BoxStage(
        text: 'Agora, aponte o celular verticalmente em direção ao paciente.',
        image: twoState),
    BoxStage(
        text: 'Clique no botão e acompanhe o paciente caminhar.',
        image: threeState),
    BoxStage(
      text: 'Estamos em fase de teste, não se preocupe com o resultado.',
      image: fourState,
      width: 100,
    ),
  ];

  @override
  _UsageInformationState createState() => _UsageInformationState();
}

class _UsageInformationState extends State<UsageInformation> {
  int _currentIndex = 0;

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
      height: 200,
      autoPlayCurve: Curves.fastOutSlowIn,
      aspectRatio: 2.0,
      onPageChanged: (index) {
        this.setState(() {
          this._currentIndex = index;
        });
      },
      items: this.widget.cardList.map((card) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: primaryColor,
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
  final String image;
  final double width;

  const BoxStage({Key key, this.text, this.image, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          this.image,
          width: width,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(color: ternaryColor),
          ),
        )
      ],
    );
  }
}