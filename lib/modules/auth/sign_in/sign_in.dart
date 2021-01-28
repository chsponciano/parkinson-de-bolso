import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/route.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/redefine_password.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_up/sign_up.dart';
import 'package:parkinson_de_bolso/modules/dashboard/dashboard_module.dart';
import 'package:parkinson_de_bolso/service/user_service.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';
import 'package:parkinson_de_bolso/widget/custom_anchor_text.dart';
import 'package:parkinson_de_bolso/widget/custom_checkbox.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_field.dart';

class SignIn extends StatefulWidget {
  static const String routeName = '/signInRoute';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SharedPreferencesUtil{
  TextEditingController _email;
  TextEditingController _password;
  var _remember;
  var _loading;

  @override
  void initState() {
    this._email = TextEditingController();
    this._password = TextEditingController();
    this._remember = false;
    this._loading = false;
    super.initState();
    this.validateCachedUser();
  }

  void validateCachedUser() async {
    String email = await this.getPrefs('user_email');
    String password = await this.getPrefs('user_password');
    if (email != null && email.isNotEmpty && password != null && password.isNotEmpty) {
      this.authenticate(email, password);
    }
  }

  void authenticate(String email, String password) {
    this.setState(() => this._loading = true);
    UserService.instance.authenticate(email, password).then((Map value) {
      RouteHandler.loggedInUser = UserModel.fromJson(value['user']);
      RouteHandler.token = value['token'];
      if (this._remember) {
        this.addPrefs('user_email', email);
        this.addPrefs('user_password', password);
      }
      this.setState(() => this._loading = false);
      Navigator.pushNamed(context, DashboardModule.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleSignIn,
      loading: this._loading,
      children: [
        CustomTextField(
          controller: this._email,
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'E-mail',
          hint: 'Digite seu e-mail',
          icon: Icons.email,
          padding: EdgeInsets.only(top: 14.0),
          type: TextInputType.emailAddress,
          distanceNextLine: 30.0,
        ),
        CustomTextField(
          controller: this._password,
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'Senha',
          hint: 'Digite sua senha',
          icon: Icons.lock,
          padding: EdgeInsets.only(top: 14.0),
          distanceNextLine: 10.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomCheckbox(
              activeColor: ternaryColor,
              checkColor: primaryColor,
              caption: 'Lembrar',
              remember: (value) => setState(() => this._remember = value),
              height: 20.0,
            ),
            CustomAnchorText(
              alignment: Alignment.centerRight,
              caption: 'Esqueceu a senha?',
              color: ternaryColor,
              onPressed: () => Navigator.pushNamed(context, RedefinePassword.routeName)
            )
          ],
        ),
        SizedBox(height: 15),
        CustomRaisedButton(
          label: 'Acessar',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () => this.authenticate(this._email.text, this._password.text),
          textColor: primaryColor,
          elevation: 5.0,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUp.routeName),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Ainda não tem uma conta? ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Clique aqui!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
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
