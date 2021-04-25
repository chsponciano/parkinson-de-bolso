import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:parkinson_de_bolso/adapter/dialog.adapter.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.verification.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/extra/auth.base.dart';
import 'package:parkinson_de_bolso/util/validationField.util.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class RedefinePasswordPage extends StatefulWidget {
  static const String routeName = '/RedefinePasswordPageRoute';

  @override
  _RedefinePasswordPageState createState() => _RedefinePasswordPageState();
}

class _RedefinePasswordPageState extends State<RedefinePasswordPage>
    with ValidationFieldUtil {
  GlobalKey<FormState> _formKey;
  TextEditingController _email;
  EdgeInsets _padding;
  EdgeInsets _internalPadding;
  bool _loading;

  @override
  void initState() {
    this._formKey = GlobalKey<FormState>();
    this._email = TextEditingController();
    this._padding = EdgeInsets.symmetric(vertical: 20, horizontal: 0);
    this._internalPadding = EdgeInsets.all(20);
    this._loading = false;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AuthBase(
      widgetTitle: 'Redefinir senha',
      activateBackButton: true,
      loading: this._loading,
      children: [
        SizedBox(height: 10),
        Text(
          'Esqueceu a senha? Preecha o campo abaixo para reiniciar a senha.',
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
            ],
          ),
        ),
        CustomRaisedButton(
          label: 'Redefinir senha',
          width: double.infinity,
          background: ThemeConfig.ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 5.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () {
            if (this._formKey.currentState.validate()) {
              this.setState(() => this._loading = true);
              AwsAdapter.instance.forgotPassword(this._email.text).then((_) {
                Navigator.pushNamed(context, VerificationCodePage.routeName);
              }).catchError((_) {
                DialogAdapter.instance.show(
                  context,
                  DialogType.ERROR,
                  'Erro no processo',
                  'Ocorreu algum erro, favor tentar novamente!',
                );
              }).whenComplete(() => this.setState(() => this._loading = false));
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
