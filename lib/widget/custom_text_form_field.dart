import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';

class CustomTextFormField extends StatelessWidget {
  final String fieldName;
  final String hintText;
  final Function onSaved;
  final bool isPassword;
  final TextInputType type;
  final IconData prefixIcon;
  final double width;
  final List<TextInputFormatter> inputFormatters;
  final Function onTap;
  final bool showCursor;
  final bool readOnly;
  final TextEditingController controller;
  final FocusNode focusNode;

  CustomTextFormField({@required this.fieldName, @required this.hintText, @required this.onSaved, this.isPassword = false, this.type = TextInputType.text, @required this.prefixIcon, this.width, this.inputFormatters, this.onTap, this.showCursor = true, this.readOnly = false, this.controller, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: this.width,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          onTap: (this.onTap != null) ? () => this.onTap.call() : null,
          showCursor: this.showCursor,
          readOnly: this.readOnly,
          controller: this.controller,
          focusNode: this.focusNode,
          inputFormatters: this.inputFormatters,
          decoration: InputDecoration(
            prefixIcon: Icon(
              this.prefixIcon,
              color: formForegroundColor,
            ),
            hintText: this.hintText,
            contentPadding: EdgeInsets.all(15.0),
            border: InputBorder.none,
            filled: true,
            fillColor: formBackgroundColor,
          ),
          obscureText: this.isPassword ? true : false,
          validator: (String value) => (value.isEmpty) ? 'Campo obrigatório' : null,
          onSaved: this.onSaved,
          keyboardType: this.type,
        ),
      ),
    );
  }
}