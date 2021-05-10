import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';

class TextFormFieldWidget extends StatelessWidget {
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
  final bool transparent;
  final EdgeInsets padding;
  final EdgeInsets internalPadding;
  final Function validation;
  final Function onChanged;
  final Widget suffix;

  TextFormFieldWidget(
      {@required this.fieldName,
      @required this.hintText,
      this.onSaved,
      this.isPassword = false,
      this.type = TextInputType.text,
      @required this.prefixIcon,
      this.width,
      this.inputFormatters,
      this.onTap,
      this.showCursor = true,
      this.readOnly = false,
      this.controller,
      this.focusNode,
      this.transparent = false,
      this.padding,
      this.internalPadding,
      this.validation,
      this.onChanged,
      this.suffix});

  InputDecoration _getTransparent(double paddingValue) {
    final OutlineInputBorder _inputBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: ThemeConfig.alternativeColorTransparency,
    ));

    return InputDecoration(
      suffixIcon: this.suffix,
      enabledBorder: _inputBorder,
      focusedBorder: _inputBorder,
      errorBorder: _inputBorder,
      focusedErrorBorder: _inputBorder,
      errorStyle: TextStyle(
        color: ThemeConfig.alternativeColorTransparency,
      ),
      prefixIcon: Icon(
        this.prefixIcon,
        color: ThemeConfig.alternativeColorTransparency,
      ),
      hintStyle: TextStyle(
        color: ThemeConfig.alternativeColorTransparency,
      ),
      hintText: this.hintText,
      contentPadding: this.internalPadding != null
          ? this.internalPadding
          : EdgeInsets.all(paddingValue),
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.transparent,
    );
  }

  InputDecoration _getColorful(double paddingValue) {
    return InputDecoration(
      suffixIcon: this.suffix,
      prefixIcon: Icon(
        this.prefixIcon,
        color: ThemeConfig.formForegroundColor,
      ),
      hintStyle: TextStyle(
        color: ThemeConfig.formForegroundColor,
      ),
      hintText: this.hintText,
      contentPadding: EdgeInsets.all(
        paddingValue,
      ),
      border: InputBorder.none,
      filled: true,
      fillColor: ThemeConfig.formBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width > 400.0 ? 16.0 : 12.0;

    return Container(
      alignment: Alignment.topCenter,
      width: this.width,
      child: Padding(
        padding: this.padding != null ? this.padding : EdgeInsets.all(10.0),
        child: TextFormField(
          onTap: (this.onTap != null) ? () => this.onTap.call() : null,
          showCursor: this.showCursor,
          readOnly: this.readOnly,
          controller: this.controller,
          focusNode: this.focusNode,
          inputFormatters: this.inputFormatters,
          decoration: this.transparent
              ? this._getTransparent(15.0)
              : this._getColorful(15.0),
          obscureText: this.isPassword ? true : false,
          validator: this.validation != null
              ? this.validation
              : (String value) => (value.isEmpty) ? 'Campo obrigatório' : null,
          onSaved: this.onSaved,
          onChanged: this.onChanged,
          keyboardType: this.type,
          textCapitalization:
              (this.type == null || this.type == TextInputType.text)
                  ? TextCapitalization.words
                  : TextCapitalization.none,
          style: this.transparent
              ? TextStyle(
                  color: ThemeConfig.alternativeColorTransparency,
                  fontSize: fontSize)
              : TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
