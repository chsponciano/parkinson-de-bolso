import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/widget/custom_value_title.dart';

class CustomButtonAlertBox {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color color;
  const CustomButtonAlertBox(
      this.icon, this.tooltip, this.onPressed, this.color);
}

class CustomAlertBox extends StatelessWidget {
  final bool visible;
  final double borderRadius;
  final double fontSize;
  final String title;
  final String content;
  final String valueContent;
  final Widget element;
  final List<CustomButtonAlertBox> buttons;

  const CustomAlertBox(
      {Key key,
      this.visible = true,
      this.borderRadius = 10.0,
      this.fontSize = 20,
      this.title,
      this.content,
      this.valueContent,
      this.buttons,
      this.element})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _size = MediaQuery.of(context).size.width / 1.5;
    final double _padding = 5;

    return Visibility(
      visible: this.visible,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: _size,
                padding: EdgeInsets.all(_padding),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(this.borderRadius),
                        topRight: Radius.circular(this.borderRadius))),
                child: Center(
                    child: Text(
                  this.title,
                  style:
                      TextStyle(color: ternaryColor, fontSize: this.fontSize),
                ))),
            Container(
                width: _size,
                padding: EdgeInsets.all(_padding * 2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(this.borderRadius),
                        bottomRight: Radius.circular(this.borderRadius))),
                child: Column(
                  children: [
                    if (this.element != null) this.element,
                    if (this.element == null)
                      CustomValueTitle(
                        title: this.content,
                        value: this.valueContent,
                        size: this.fontSize,
                      ),
                    SizedBox(height: _padding),
                    if (this.buttons != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: this.buttons.map((button) {
                          return IconButton(
                              icon: Icon(
                                button.icon,
                                size: this.fontSize * 2,
                              ),
                              color: button.color,
                              tooltip: button.tooltip,
                              onPressed: button.onPressed);
                        }).toList(),
                      )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
