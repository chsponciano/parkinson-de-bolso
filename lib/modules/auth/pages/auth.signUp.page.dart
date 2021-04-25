import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:parkinson_de_bolso/adapter/dialog.adapter.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/user.model.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.signIn.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/extra/auth.base.dart';
import 'package:parkinson_de_bolso/util/sharedPreferences.util.dart';
import 'package:parkinson_de_bolso/util/validationField.util.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/SignUpPageRoute';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with ValidationFieldUtil, SharedPreferencesUtil {
  GlobalKey<FormState> _formKey;
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _password;
  UserModel _user;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
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
    return AuthBase(
      widgetTitle: 'Criar conta',
      activateBackButton: true,
      loading: this._loading,
      children: [
        Form(
            key: this._formKey,
            child: Column(
              children: [
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
                      setState(
                        () => this._loading = true,
                      );
                      AwsAdapter.instance.signUp(this._user).then((_) {
                        this.addPrefs('user_email', this._user.email);
                        this.addPrefs('user_password', this._user.password);
                        Navigator.pushNamed(context, SignInPage.routeName);
                      }).catchError((error) {
                        DialogAdapter.instance.show(
                          context,
                          DialogType.ERROR,
                          'Erro no processo',
                          'Ocorreu algum erro, favor tentar novamente!',
                        );
                      }).whenComplete(
                        () => this.setState(() => this._loading = false),
                      );
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
