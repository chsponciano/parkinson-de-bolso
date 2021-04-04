import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class CustomDateFormField extends StatefulWidget {
  final TextEditingController controller;
  final String fieldName;
  final String hintText;
  final Function onSaved;
  final IconData prefixIcon;
  final double width;
  final List<FocusNode> focusNode;

  CustomDateFormField(
      {@required this.hintText,
      @required this.onSaved,
      @required this.prefixIcon,
      @required this.width,
      @required this.fieldName,
      this.controller,
      @required this.focusNode});

  @override
  _CustomDateFormFieldState createState() => _CustomDateFormFieldState();
}

class FirstDisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  TextEditingController _controller;
  final _format = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    this._controller = (this.widget.controller != null)
        ? this.widget.controller
        : TextEditingController();
    super.initState();
  }

  void _selectDateOnCalendar() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme:
                ColorScheme.light(primary: ThemeConfig.dashboardBarColor),
          ),
          child: child,
        );
      },
    ).then((date) => {
          if (date != null)
            {
              this.setState(() {
                this._controller.text = this._format.format(date);
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      fieldName: this.widget.fieldName,
      onSaved: this.widget.onSaved,
      width: this.widget.width,
      hintText: this.widget.hintText,
      prefixIcon: this.widget.prefixIcon,
      controller: this._controller,
      onTap: () {
        this.widget.focusNode.forEach((field) => field.unfocus());
        this._selectDateOnCalendar();
      },
      showCursor: false,
      readOnly: false,
      type: TextInputType.datetime,
      focusNode: FirstDisabledFocusNode(),
    );
  }
}
