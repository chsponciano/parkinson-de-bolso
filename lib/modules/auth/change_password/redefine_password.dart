import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/route.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/verification_code.dart';
import 'package:parkinson_de_bolso/service/password_reset_service.dart';
import 'package:parkinson_de_bolso/service/user_service.dart';
import 'package:parkinson_de_bolso/util/validation_field_util.dart';
import 'package:parkinson_de_bolso/widget/custom_error_box.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class RedefinePassword extends StatefulWidget {
  static const String routeName = '/redefinePasswordRoute';

  @override
  _RedefinePasswordState createState() => _RedefinePasswordState();
}

class _RedefinePasswordState extends State<RedefinePassword> with ValidationFieldUtil {
  GlobalKey<FormState> _formKey;
  TextEditingController _email;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  bool _isExistsEmail;
  bool _errorInserting;
  bool _loading;

  @override
  void initState() { 
    this._formKey = GlobalKey<FormState>();
    this._email = TextEditingController();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._isExistsEmail = false;
    this._loading = false;
    this._errorInserting = false;
    super.initState();
  }

  String validateEmailField(String email) {
    String response;
    if (email.isNotEmpty) {
      if (this.validateEmailValue(email)) {
        if (!this._isExistsEmail) {
          response = 'E-mail não cadastrado';
        }
      } else {
        response = 'E-mail inválido';
      }
    } else {
        response = 'Campo obrigatório';
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleRedefinePassword,
      activateBackButton: true,
      loading: this._loading,
      children: [
        if (this._errorInserting)
          CustomErrorBox(message: 'Ocorreu algum erro, favor tentar novamente!'),
          SizedBox(height: 10),
        Text(
          'Esqueceu a senha? Preecha o campo abaixo para reiniciar a senha.',
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
                controller: this._email,
                fieldName: 'Email',
                hintText: 'Digite seu e-mail',
                prefixIcon: Icons.email,
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                type: TextInputType.emailAddress,
                transparent: true,
                padding: this._padding,
                internalPadding: this._internalPadding,
                validation: validateEmailField,
                onChanged: (email) async {
                  bool exists = await UserService.instance.emailExists(email);
                  this.setState(() => this._isExistsEmail = exists);
                },
              ),
            ],
          ),
        ),
        CustomRaisedButton(
          label: 'Redefinir senha',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 5.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () {
            if (this._formKey.currentState.validate()) {
              this.setState(() {
                this._loading = true;
                this._errorInserting = false;
              });
              PasswordResetService.instance.requestReset(this._email.text).then((value) {
                if (value) {
                  RouteHandler.arguments.clear();
                  RouteHandler.arguments.add(this._email.text);
                  Navigator.pushNamed(context, VerificationCode.routeName);
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