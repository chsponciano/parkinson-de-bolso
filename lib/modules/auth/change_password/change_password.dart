import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_in/sign_in.dart';
import 'package:parkinson_de_bolso/service/aws_cognito_service.dart';
import 'package:parkinson_de_bolso/widget/custom_error_box.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class ChangePassword extends StatefulWidget {
  static const String routeName = '/changePasswordRoute';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> _formKey;
  TextEditingController _password;
  TextEditingController _confirmPassword;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  bool _errorInserting;
  bool _loading;

  @override
  void initState() { 
    this._formKey = GlobalKey<FormState>();
    this._password = TextEditingController();
    this._confirmPassword = TextEditingController();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._errorInserting = false;
    this._loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleRedefinePassword,
      activateBackButton: true,
      loading: this._loading,
      children: [
        if (this._errorInserting)
          CustomErrorBox(message: 'Código Inválido!'),
          SizedBox(height: 10),
        Text(
          'Digite sua nova senha!',
          style: TextStyle(
            color: ternaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 20),
        Form(
          key: this._formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: this._password,
                fieldName: 'Nova senha',
                hintText: 'Digite sua nova senha',
                prefixIcon: Icons.lock,
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                type: TextInputType.visiblePassword,
                transparent: true,
                padding: this._padding,
                isPassword: true,
                internalPadding: this._internalPadding,
              ),
              CustomTextFormField(
                controller: this._confirmPassword,
                fieldName: 'Confirme a senha',
                hintText: 'Confirme sua nova senha',
                prefixIcon: Icons.lock,
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                type: TextInputType.visiblePassword,
                transparent: true,
                padding: this._padding,
                isPassword: true,
                internalPadding: this._internalPadding,
                validation: (String value) {
                  if (value.isEmpty) {
                    return 'Campo obrigatório';
                  }

                  if (this._password.text != value) {
                    return 'Senhas com valores diferentes';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
        CustomRaisedButton(
          label: 'Redefinir senha',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () {
            if (this._formKey.currentState.validate()) {
              this.setState(() {
                this._loading = true;
                this._errorInserting = false;
              });
              AwsCognitoService.instance.changePassword(RouteHandler.arguments[0], RouteHandler.arguments[1], this._password.text).then((value) {
                if (value) {
                  Navigator.pushNamed(context, SignIn.routeName);
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