import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/extra/auth.base.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String routeName = '/ChangePasswordPageRoute';

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey<FormState> _formKey;
  TextEditingController _password;
  TextEditingController _confirmPassword;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  bool _loading;

  @override
  void initState() {
    this._formKey = GlobalKey<FormState>();
    this._password = TextEditingController();
    this._confirmPassword = TextEditingController();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBase(
      widgetTitle: 'Redefinir senha',
      activateBackButton: true,
      loading: this._loading,
      children: [
        SizedBox(height: 10),
        Text(
          'Digite sua nova senha!',
          style: TextStyle(
              color: ThemeConfig.ternaryColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
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
          background: ThemeConfig.ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () {
            if (this._formKey.currentState.validate()) {
              this.setState(() => this._loading = true);
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
    );
  }
}
