import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/service/user_service.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_field.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signUpRoute';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  UserModel _userModel = UserModel();
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleSignUp,
      activateBackButton: true,
      loading: this.loading,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                borderRadius: 10.0,
                color: ternaryColor,
                height: 60.0,
                title: 'Nome',
                hint: 'Digite seu nome',
                icon: Icons.people,
                padding: EdgeInsets.only(top: 14.0),
                type: TextInputType.name,
                distanceNextLine: 30.0,
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                onSaved: (name) => this._userModel.name = name,
              ),
              CustomTextField(
                borderRadius: 10.0,
                color: ternaryColor,
                height: 60.0,
                title: 'E-mail',
                hint: 'Digite seu e-mail',
                icon: Icons.email,
                padding: EdgeInsets.only(top: 14.0),
                type: TextInputType.emailAddress,
                distanceNextLine: 30.0,
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                onSaved: (email) => this._userModel.email = email,
                onChange: (email) => UserService.instance.emailExists(email).then((value) => print(value)),
              ),
              CustomTextField(
                borderRadius: 10.0,
                color: ternaryColor,
                height: 60.0,
                title: 'Senha',
                hint: 'Digite sua senha',
                icon: Icons.lock,
                padding: EdgeInsets.only(top: 14.0),
                distanceNextLine: 10.0,
                onSaved: (password) => this._userModel.password = password,
              ),
              CustomRaisedButton(
                label: 'Criar conta',
                width: double.infinity,
                background: ternaryColor,
                padding: EdgeInsets.symmetric(vertical: 25.0),
                paddingInternal: EdgeInsets.all(15.0),
                onPressed: () {
                  if (this._formKey.currentState.validate()) {
                    this._formKey.currentState.save();
                    setState(() => this.loading = true);
                    UserService.instance.create(this._userModel).then((value) {
                      setState(() => this.loading = false);
                    });
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
          )
        ),
      ],
    );
  }
}