import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/route.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/change_password.dart';
import 'package:parkinson_de_bolso/service/password_reset_service.dart';
import 'package:parkinson_de_bolso/widget/custom_error_box.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class VerificationCode extends StatefulWidget {
  static const String routeName = '/verificationCodeRoute';

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  GlobalKey<FormState> _formKey;
  TextEditingController _code;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  bool _invalidCode;
  bool _errorInserting;
  bool _loading;

  @override
  void initState() { 
    this._formKey = GlobalKey<FormState>();
    this._code = TextEditingController();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._invalidCode = false;
    this._errorInserting = false;
    this._loading = false;
    super.initState();
  }

  String validateCode(String code) {
    if (code.isEmpty) {
      return 'Campo obrigatório';
    }

    if (this._invalidCode) {
      return 'Código invalido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleRedefinePassword,
      activateBackButton: true,
      loading: this._loading,
      children: [
        if (this._errorInserting)
          CustomErrorBox(message: 'Código inválido, favor conferir seu e-mail!'),
          SizedBox(height: 10),
        Text(
          'Digite o código enviado em seu e-mail.',
          style: TextStyle(
            color: ternaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 10),
        Form(
          key: this._formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: this._code,
                fieldName: 'Código',
                hintText: 'Digite o código',
                prefixIcon: Icons.confirmation_number,
                inputFormatters: [new LengthLimitingTextInputFormatter(6)],
                type: TextInputType.number,
                transparent: true,
                padding: this._padding,
                internalPadding: this._internalPadding,
                validation: validateCode,
                onChanged: (code) async {
                  bool right = true;
                  this.setState(() => this._invalidCode = !right);
                },
              ),
            ],
          ),
        ),
        CustomRaisedButton(
          label: 'Confirmar reinicio',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () {
            this.setState(() {
              this._loading = true;
              this._errorInserting = false;
            });
            if (this._formKey.currentState.validate()) {
              PasswordResetService.instance.validateCode(RouteHandler.arguments[0], this._code.text).then((value) {
                if (value) {
                  Navigator.pushNamed(context, ChangePassword.routeName);
                } else {
                  this.setState(() => this._errorInserting = true);
                }
              }).whenComplete(() => this.setState(() => this._loading = false));
            }
          },
          textColor: primaryColor,
          elevation: 5.0,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

}