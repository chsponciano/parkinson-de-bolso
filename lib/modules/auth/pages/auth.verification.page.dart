import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.changePassword.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/extra/auth.base.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class VerificationCodePage extends StatefulWidget {
  static const String routeName = '/VerificationCodePageRoute';

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  GlobalKey<FormState> _formKey;
  TextEditingController _code;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  bool _loading;

  @override
  void initState() {
    this._formKey = GlobalKey<FormState>();
    this._code = TextEditingController();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._loading = false;
    super.initState();
  }

  String validateCode(String code) {
    if (code.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
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
          'Digite o código enviado em seu e-mail.',
          style: TextStyle(
              color: ThemeConfig.ternaryColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Form(
          key: this._formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: this._code,
                fieldName: 'Código',
                hintText: 'Digite o código',
                prefixIcon: Icons.confirmation_number,
                inputFormatters: [new LengthLimitingTextInputFormatter(6)],
                type: TextInputType.number,
                transparent: true,
                padding: this._padding,
                internalPadding: this._internalPadding,
                validation: validateCode,
              ),
            ],
          ),
        ),
        CustomRaisedButton(
          label: 'Confirmar reinicio',
          width: double.infinity,
          background: ThemeConfig.ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () {
            if (this._formKey.currentState.validate()) {
              // RouteConfig.arguments.add(this._code.text);
              Navigator.pushNamed(context, ChangePasswordPage.routeName);
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
