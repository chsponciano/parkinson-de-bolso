import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_in/sign_in.dart';
import 'package:parkinson_de_bolso/service/aws_cognito_service.dart';
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

class _SignUpState extends State<SignUp>
    with ValidationFieldUtil, SharedPreferencesUtil {
  GlobalKey<FormState> _formKey;
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _password;
  UserModel _user;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  String _errorMessage;
  bool _errorInserting;
  bool _loading;
  Icon _passwordPolicyIcon;
  List<Row> _passwordPolicyMessage;

  @override
  void initState() {
    this._passwordPolicyMessage = new List<Row>();
    this._formKey = GlobalKey<FormState>();
    this._name = TextEditingController();
    this._email = TextEditingController();
    this._password = TextEditingController();
    this._user = UserModel();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._errorInserting = false;
    this._loading = false;
    super.initState();
  }

  String validatePasswordField(String password) {
    String response;
    if (password.isNotEmpty) {
      if (!this.validatePasswordValue(password)) {
        response = 'Senha muito fraca';
      }
    } else {
      response = 'Campo obrigatório';
    }
    return response;
  }

  String validateEmailField(String email) {
    String response;
    if (email.isNotEmpty) {
      if (!this.validateEmailValue(email)) {
        response = 'E-mail inválido';
      }
    } else {
      response = 'Campo obrigatório';
    }
    return response;
  }

  void _addPolicies(String rule) {
    this._passwordPolicyMessage.add(Row(
          children: [
            Icon(
              Icons.close,
              color: Colors.white,
              size: 15,
            ),
            SizedBox(width: 10),
            Text(
              rule,
              style: TextStyle(color: Colors.white),
            )
          ],
        ));
  }

  void _applyPolicies(String value) {
    Widget icon;
    this._passwordPolicyMessage.clear();

    if (value.isNotEmpty) {
      if (!this.hasNDigits(8, value)) {
        this._addPolicies('Deve conter oito digitos');
      }

      if (this.containsLower(value)) {
        this._addPolicies('Falta letra miníscula');
      }

      if (this.containsUppercase(value)) {
        this._addPolicies('Falta letra maiúscula');
      }

      if (this.containsSpecialCharacters(value)) {
        this._addPolicies('Falta caracter especial');
      }

      if (this.containsNumber(value)) {
        this._addPolicies('Falta número');
      }

      icon = Icon(
          (this._passwordPolicyMessage.length > 0)
              ? Icons.warning_rounded
              : Icons.done_rounded,
          color: Colors.white);
    }

    this.setState(() {
      this._passwordPolicyIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: 'Criar conta',
      activateBackButton: true,
      loading: this._loading,
      children: [
        Form(
            key: this._formKey,
            child: Column(
              children: [
                if (this._errorInserting)
                  CustomErrorBox(
                      message: (this._errorMessage != null)
                          ? this._errorMessage
                          : 'Ocorreu algum erro, favor tentar novamente!'),
                CustomTextFormField(
                  controller: this._name,
                  fieldName: 'Nome',
                  hintText: 'Digite seu nome',
                  prefixIcon: Icons.person,
                  inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                  onSaved: (name) => this._user.name = name,
                  type: TextInputType.text,
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
                  type: TextInputType.emailAddress,
                  transparent: true,
                  padding: this._padding,
                  internalPadding: this._internalPadding,
                  validation: validateEmailField,
                ),
                CustomTextFormField(
                  onChanged: (value) => this._applyPolicies(value),
                  suffix: this._passwordPolicyIcon,
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
                  validation: validatePasswordField,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: this._passwordPolicyMessage,
                    )
                  ],
                ),
                SizedBox(height: 10),
                CustomRaisedButton(
                  label: 'Criar conta',
                  width: double.infinity,
                  background: ThemeConfig.ternaryColor,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  paddingInternal: EdgeInsets.all(15.0),
                  onPressed: () {
                    if (this._formKey.currentState.validate()) {
                      this._formKey.currentState.save();
                      setState(() {
                        this._loading = true;
                        this._errorInserting = false;
                        this._errorMessage = null;
                      });

                      AwsCognitoService.instance.signUp(this._user).then((_) {
                        this.addPrefs('user_email', this._user.email);
                        this.addPrefs('user_password', this._user.password);
                        Navigator.pushNamed(context, SignIn.routeName);
                      }).catchError((error) {
                        this.setState(() {
                          this._errorInserting = true;
                          if (error is String) this._errorMessage = error;
                        });
                      }).whenComplete(
                          () => this.setState(() => this._loading = false));
                    }
                  },
                  textColor: ThemeConfig.primaryColor,
                  elevation: 5.0,
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
