import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/adapter/dialog.adapter.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/service/patient.service.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar_button.dart';
import 'package:parkinson_de_bolso/widget/custom_date_form_field.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class PatientFormPage extends StatefulWidget {
  static final String creationFormName = 'Adicionar Paciente';
  static final String changeFormName = 'Alterar Paciente';

  final PatientModel patient;
  final double horizontalPadding;
  final double spacingBetweenFields;

  PatientFormPage(
      {Key key,
      this.patient,
      this.horizontalPadding = 10.0,
      this.spacingBetweenFields = 20.0})
      : super(key: key);

  @override
  _PatientFormPageState createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> with DateTimeUtil {
  final _format = DateFormat('dd/MM/yyyy');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldControl = TextEditingController();
  final TextEditingController _birthdayFieldControl = TextEditingController();
  final TextEditingController _diagnosticFieldControl = TextEditingController();
  final TextEditingController _weightFieldControl = TextEditingController();
  final TextEditingController _heightFieldControl = TextEditingController();
  final FocusNode _nameFocus = new FocusNode();
  final FocusNode _weightFocus = new FocusNode();
  final FocusNode _heightFocus = new FocusNode();
  final DialogAdapter _dialogAdapter = DialogAdapter.instance;
  bool loading;
  PatientModel _patient;
  String _id;

  @override
  void initState() {
    if (this.widget.patient != null) {
      this._patient = this.widget.patient.clone();
      this._id = this.widget.patient.id;
      this._nameFieldControl.text = this._patient.fullname;
      this._birthdayFieldControl.text = this._format.format(
            this._patient.birthdate,
          );
      this._diagnosticFieldControl.text = this._format.format(
            this._patient.diagnosis,
          );
      this._weightFieldControl.text = this._patient.weight.toString();
      this._heightFieldControl.text = this._patient.height.toString();
    } else {
      this._patient = PatientModel();
    }
    this.loading = false;
    super.initState();
  }

  void _reset() {
    setState(() {
      this._patient = PatientModel();
      this._nameFieldControl.clear();
      this._birthdayFieldControl.clear();
      this._diagnosticFieldControl.clear();
      this._weightFieldControl.clear();
      this._heightFieldControl.clear();
    });
  }

  void _create() {
    this.setState(() => this.loading = true);
    PatientService.instance.create(this._patient).then((PatientModel patient) {
      this._reset();
      this._dialogAdapter.show(
            context,
            DialogType.SUCCES,
            'Criação de paciente',
            'Paciente ${patient.fullname.split(' ')[0]} adicionado com sucesso!',
          );
    }).catchError((_) {
      this._dialogAdapter.show(
            context,
            DialogType.ERROR,
            'Criação de paciente',
            'Erro ao inserir, tentar novamente',
          );
    }).whenComplete(() => this.setState(() => this.loading = false));
  }

  void _update() {
    this.setState(() => this.loading = true);
    PatientService.instance.update(this._patient).then((PatientModel patient) {
      this.setState(() {
        this._patient = this.widget.patient;
        this._patient = patient;
        this._patient.id = this._id;
      });
      this._dialogAdapter.show(
            context,
            DialogType.SUCCES,
            'Alteração de paciente',
            'Paciente ${patient.fullname.split(' ')[0]} alterado com sucesso!',
          );
    }).catchError((_) {
      this._dialogAdapter.show(
            context,
            DialogType.ERROR,
            'Alteração de paciente',
            'Erro ao alterar, tentar novamente',
          );
    }).whenComplete(() => this.setState(() => this.loading = false));
  }

  void _submit() async {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      (this.widget.patient != null) ? this._update() : this._create();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _halfMediaWidth = (MediaQuery.of(context).size.width / 2.0) -
        this.widget.horizontalPadding;

    return CustomBackground(
        topColor: ThemeConfig.dashboardBarColor,
        bottomColor: ThemeConfig.ternaryColor,
        loading: this.loading,
        bottom: Container(
          padding: EdgeInsets.only(top: 30),
          child: Form(
            key: this._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCircleAvatarButton(
                  background: ThemeConfig.formBackgroundColor,
                  foreground: ThemeConfig.formForegroundColor,
                  radius: 100.0,
                  icon: Icons.add_a_photo,
                  image: this._patient.image,
                  imageUrl: this._patient.imageUrl,
                  setImage: (image) {
                    this.setState(() {
                      this._patient.image = image;
                      this._patient.imageUrl = null;
                    });
                  },
                ),
                SizedBox(height: this.widget.spacingBetweenFields),
                CustomTextFormField(
                  focusNode: this._nameFocus,
                  controller: this._nameFieldControl,
                  fieldName: 'Nome',
                  hintText: 'Nome Completo',
                  prefixIcon: Icons.person,
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  onSaved: (name) => this._patient.fullname = name,
                ),
                SizedBox(height: this.widget.spacingBetweenFields),
                Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDateFormField(
                        controller: this._birthdayFieldControl,
                        fieldName: 'Nascimento',
                        width: _halfMediaWidth,
                        hintText: 'Nascimento',
                        prefixIcon: Icons.calendar_today,
                        onSaved: (birthdate) => this._patient.birthdate = this
                            .strToDate(birthdate, DateTimeFormatUtil.BR_DATE),
                        focusNode: [
                          this._heightFocus,
                          this._weightFocus,
                          this._nameFocus
                        ],
                      ),
                      CustomDateFormField(
                        controller: this._diagnosticFieldControl,
                        fieldName: 'Diagnóstico',
                        width: _halfMediaWidth,
                        hintText: 'Diagnóstico',
                        prefixIcon: Icons.medical_services,
                        onSaved: (diagnosis) => this._patient.diagnosis = this
                            .strToDate(diagnosis, DateTimeFormatUtil.BR_DATE),
                        focusNode: [
                          this._heightFocus,
                          this._weightFocus,
                          this._nameFocus
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: this.widget.spacingBetweenFields),
                Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        focusNode: this._weightFocus,
                        controller: this._weightFieldControl,
                        fieldName: 'Peso',
                        width: _halfMediaWidth,
                        hintText: 'Peso',
                        prefixIcon: Icons.line_weight,
                        type: TextInputType.number,
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(10)
                        ],
                        onSaved: (weight) => this._patient.weight = weight,
                      ),
                      CustomTextFormField(
                        focusNode: this._heightFocus,
                        controller: this._heightFieldControl,
                        fieldName: 'Altura',
                        width: _halfMediaWidth,
                        hintText: 'Altura',
                        prefixIcon: Icons.height,
                        type: TextInputType.number,
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(10)
                        ],
                        onSaved: (height) => this._patient.height = height,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: this.widget.spacingBetweenFields),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: ThemeConfig.primaryColor,
                      textColor: ThemeConfig.ternaryColor,
                      child: Text(
                        (this.widget.patient != null) ? 'Alterar' : 'Criar',
                      ),
                      onPressed: this._submit,
                    ),
                    SizedBox(width: this.widget.spacingBetweenFields),
                    RaisedButton(
                      color: ThemeConfig.ternaryColor,
                      textColor: ThemeConfig.primaryColor,
                      child: Text('Limpar'),
                      onPressed: this._reset,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        horizontalPadding: this.widget.horizontalPadding,
        margin: 10.0);
  }
}
