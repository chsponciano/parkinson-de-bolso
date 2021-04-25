import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:parkinson_de_bolso/adapter/dialog.adapter.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.redefinePassword.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.signUp.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/extra/auth.base.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
import 'package:parkinson_de_bolso/util/sharedPreferences.util.dart';
import 'package:parkinson_de_bolso/util/validationField.util.dart';
import 'package:parkinson_de_bolso/widget/custom_checkbox.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/signIn';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SharedPreferencesUtil, ValidationFieldUtil {
  GlobalKey<FormState> _formKey;
  TextEditingController _email;
  TextEditingController _password;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  var _remember;
  var _loading;

  @override
  void initState() {
    this._formKey = GlobalKey<FormState>();
    this._email = TextEditingController();
    this._password = TextEditingController();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._remember = false;
    this._loading = false;
    super.initState();
    this.validateCachedUser();
  }

  void validateCachedUser() async {
    String email = await this.getPrefs('user_email');
    String password = await this.getPrefs('user_password');
    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      this.authenticate(email, password, true);
    }
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

  void authenticate(String email, String password, bool inCache) {
    if (inCache || this._formKey.currentState.validate()) {
      this.setState(() => this._loading = true);
      AwsAdapter.instance.signIn(email, password).then((_) {
        if (this._remember) {
          this.addPrefs('user_email', email);
          this.addPrefs('user_password', password);
        }
        DashboardActions.instance.setPatientListRoute();
      }).catchError((error) {
        DialogAdapter.instance.show(
          context,
          DialogType.ERROR,
          'Erro no processo',
          error.toString(),
        );
      }).whenComplete(
        () => this.setState(() => this._loading = false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBase(
      widgetTitle: 'Acessar conta',
      loading: this._loading,
      children: [
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
                ),
                CustomTextFormField(
                  controller: this._password,
                  fieldName: 'Senha',
                  hintText: 'Digite sua senha',
                  prefixIcon: Icons.lock,
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  type: TextInputType.visiblePassword,
                  transparent: true,
                  isPassword: true,
                  padding: this._padding,
                  internalPadding: this._internalPadding,
                ),
              ],
            )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomCheckbox(
              activeColor: ThemeConfig.ternaryColor,
              checkColor: ThemeConfig.primaryColor,
              caption: 'Lembrar',
              remember: (value) => setState(() => this._remember = value),
              height: 20.0,
            ),
            TextButton(
              child: Text(
                'Esqueceu a senha?',
                style: TextStyle(color: ThemeConfig.ternaryColor),
              ),
              onPressed: () => Navigator.pushNamed(
                context,
                RedefinePasswordPage.routeName,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        CustomRaisedButton(
          label: 'Acessar',
          width: double.infinity,
          background: ThemeConfig.ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () =>
              this.authenticate(this._email.text, this._password.text, false),
          textColor: ThemeConfig.primaryColor,
          elevation: 5.0,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpPage.routeName),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Ainda não tem uma conta? ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Clique aqui!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
