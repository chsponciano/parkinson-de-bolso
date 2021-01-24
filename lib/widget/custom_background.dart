import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/constant/assest_path.dart';

class CustomBackground extends StatefulWidget {
  final Color topColor;
  final Color bottomColor;
  final Widget top;
  final Widget bottom;
  final double horizontalPadding;
  final Widget footer;
  final double margin;
  final bool dataValidation;

  CustomBackground({@required this.topColor, @required this.bottomColor, this.top, @required this.bottom, @required this.horizontalPadding, this.footer, @required this.margin, this.dataValidation = true});

  @override
  _CustomBackgroundState createState() => _CustomBackgroundState();
}

class _CustomBackgroundState extends State<CustomBackground> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: this.widget.topColor
          ),
          child: Column(
            children: [
              if (this.widget.top != null)
                this.widget.top,
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: this.widget.margin),
                  decoration: BoxDecoration(
                    color: this.widget.bottomColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(50))
                  ),
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: this.widget.horizontalPadding, vertical: 10),
                    child: Center(
                      child: this.widget.dataValidation ? 
                        this.widget.bottom : 
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Column(
                            children: [
                              Text(
                                'Sem dados para a exibição',
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColor
                                ),
                              ),
                              Image(
                                image: AssetImage(noData),
                                height: 300,
                              )
                            ],
                          ),
                        )
                    )
                  ),
                ),
              ),
              if (this.widget.footer != null && this.widget.dataValidation)
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: this.widget.bottomColor
                    ),
                    child: this.widget.footer
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}