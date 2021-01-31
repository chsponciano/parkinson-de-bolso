import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_in/sign_in.dart';
import 'package:parkinson_de_bolso/service/user_service.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';
import 'package:parkinson_de_bolso/util/validation_field_util.dart';
import 'package:parkinson_de_bolso/widget/custom_error_box.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signUpRoute';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with ValidationFieldUtil, SharedPreferencesUtil {
  GlobalKey<FormState> _formKey;
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _password;
  UserModel _user;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  bool _errorInserting;
  bool _loading;
  bool _isExistsEmail;

  @override
  void initState() { 
    this._formKey = GlobalKey<FormState>();
    this._name = TextEditingController();
    this._email = TextEditingController();
    this._password = TextEditingController();
    this._user = UserModel();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._errorInserting = false;
    this._loading = false;
    this._isExistsEmail = false;
    super.initState();
  }

  String validateEmailField(String email) {
    String response;
    if (email.isNotEmpty) {
      if (this.validateEmailValue(email)) {
        if (this._isExistsEmail) {
          response = 'E-mail já cadastrado';
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
      widgetTitle: titleSignUp,
      activateBackButton: true,
      loading: this._loading,
      children: [
        Form(
          key: this._formKey,
          child: Column(
            children: [
              if (this._errorInserting)
                CustomErrorBox(message: 'Ocorreu algum erro, favor tentar novamente!'),
              CustomTextFormField(
                controller: this._name,
                fieldName: 'Nome',
                hintText: 'Digite seu nome',
                prefixIcon: Icons.person,
                inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-zA-ZÄäÖöÜü]"))],
                onSaved: (name) => this._user.name = name,
                type: TextInputType.name,
                transparent: true,
                padding: this._padding,
                internalPadding: this._internalPadding,
              ),
              CustomTextFormField(
                controller: this._email,
                fieldName: 'Email',
                hintText: 'Digite seu e-mail',
                prefixIcon: Icons.email,
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                onSaved: (email) => this._user.email = email,
                onChanged: (email) async {
                  bool exists = await UserService.instance.emailExists(email);
                  this.setState(() => this._isExistsEmail = exists);
                },
                type: TextInputType.emailAddress,
                transparent: true,
                padding: this._padding,
                internalPadding: this._internalPadding,
                validation: validateEmailField,
              ),
              CustomTextFormField(
                controller: this._password,
                fieldName: 'Senha',
                hintText: 'Digite sua senha',
                prefixIcon: Icons.lock,
                inputFormatters: [new LengthLimitingTextInputFormatter(15)],
                onSaved: (password) => this._user.password = password,
                type: TextInputType.visiblePassword,
                transparent: true,
                padding: this._padding,
                internalPadding: this._internalPadding,
                isPassword: true,
              ),
              CustomRaisedButton(
                label: 'Criar conta',
                width: double.infinity,
                background: ternaryColor,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                paddingInternal: EdgeInsets.all(15.0),
                onPressed: () {
                  if (this._formKey.currentState.validate()) {
                    this._formKey.currentState.save();
                    setState(() {
                      this._loading = true;
                      this._errorInserting = false;
                    });
                    UserService.instance.create(this._user).then((value) {
                      this.addPrefs('user_email', this._user.email);
                      this.addPrefs('user_password', this._user.password);
                      Navigator.pushNamed(context, SignIn.routeName);
                    }).catchError((_) => setState(() => this._errorInserting = true))
                    .whenComplete(() => setState(() => this._loading = false));
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