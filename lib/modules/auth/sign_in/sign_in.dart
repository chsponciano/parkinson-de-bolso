import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/redefine_password.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_up/sign_up.dart';
import 'package:parkinson_de_bolso/modules/dashboard/dashboard_module.dart';
import 'package:parkinson_de_bolso/service/user_service.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';
import 'package:parkinson_de_bolso/util/validation_field_util.dart';
import 'package:parkinson_de_bolso/widget/custom_anchor_text.dart';
import 'package:parkinson_de_bolso/widget/custom_checkbox.dart';
import 'package:parkinson_de_bolso/widget/custom_error_box.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class SignIn extends StatefulWidget {
  static const String routeName = '/signInRoute';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SharedPreferencesUtil, ValidationFieldUtil {
  GlobalKey<FormState> _formKey;
  TextEditingController _email;
  TextEditingController _password;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  var _invalidPassword;
  var _remember;
  var _loading;

  @override
  void initState() { 
    this._formKey = GlobalKey<FormState>();
    this._email = TextEditingController();
    this._password = TextEditingController();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._invalidPassword = false;
    this._remember = false;
    this._loading = false;
    super.initState();
    this.validateCachedUser();
  }

  void validateCachedUser() async {
    String email = await this.getPrefs('user_email');
    String password = await this.getPrefs('user_password');
    if (email != null && email.isNotEmpty && password != null && password.isNotEmpty) {
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
      this.setState(() {
        this._loading = true;
        this._invalidPassword = false;
      });

      UserService.instance.authenticate(email, password).then((Map value) {
        RouteHandler.loggedInUser = UserModel.fromJson(value['user']);
        RouteHandler.token = value['token'];
        if (this._remember) {
          this.addPrefs('user_email', email);
          this.addPrefs('user_password', password);
        }
        Navigator.pushNamed(context, DashboardModule.routeName);
      }).catchError((_) {
        this.setState(() {
          this._invalidPassword = true;
        });
      }).whenComplete(() => this.setState(() {
        this._loading = false;
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleSignIn,
      loading: this._loading,
      children: [
        Form(
          key: this._formKey,
          child: Column(
            children: [
              if (this._invalidPassword)
                CustomErrorBox(message: 'E-mail e/ou senha incorreta'),
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
          )
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
        SizedBox(height: 5),
        CustomRaisedButton(
          label: 'Acessar',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () => this.authenticate(this._email.text, this._password.text, false),
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
