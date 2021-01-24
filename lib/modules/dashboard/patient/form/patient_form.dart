import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/util/snackbar_util.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar_button.dart';
import 'package:parkinson_de_bolso/widget/custom_date_form_field.dart';
import 'package:parkinson_de_bolso/widget/custom_text_form_field.dart';

class PatientForm extends StatefulWidget {
  final Function callHigher;
  final PatientModel patient;
  final double horizontalPadding;
  final double spacingBetweenFields;

  PatientForm({Key key, @required this.callHigher, this.patient, this.horizontalPadding = 10.0, this.spacingBetweenFields = 20.0}) : super(key: key);

  @override
  _PatientFormState createState() => _PatientFormState();  
}

class _PatientFormState extends State<PatientForm> with SnackbarUtil {
  final _format = DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldControl = TextEditingController();
  final TextEditingController _birthdayFieldControl = TextEditingController();
  final TextEditingController _diagnosticFieldControl = TextEditingController();
  final TextEditingController _weightFieldControl = TextEditingController();
  final TextEditingController _heightFieldControl = TextEditingController();
  PatientModel _patient;

  @override
  void initState() {
    if (this.widget.patient != null) {
      this._patient = this.widget.patient;
      this._nameFieldControl.text = this._patient.name;
      this._birthdayFieldControl.text = this._format.format(this._patient.birthDate);
      this._diagnosticFieldControl.text = this._format.format(this._patient.diagnosis);
      this._weightFieldControl.text = this._patient.weight.toString();
      this._heightFieldControl.text = this._patient.height.toString();
    } else {
      this._patient = PatientModel();
    }
    super.initState();
  }

  void _submitForm() {
    final FormState form = this._formKey.currentState;

    if (!form.validate()) {
      this.showSnackbar(this._scaffoldKey, 'Formulário inválido!  Por favor, preencher os campos.', SnackbarType.ERROR);
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Name: ${this._patient.name}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _halfMediaWidth = (MediaQuery.of(context).size.width  / 2.0) - this.widget.horizontalPadding;

    return Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: (this.widget.patient == null) ? Text('Adicionar Paciente') : Text('Editar Paciente'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp, 
            color: primaryColorDashboardBar
          ),
          onPressed: () => this.widget.callHigher.call(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save, color: 
              primaryColorDashboardBar
            ),
            onPressed: () => _submitForm()),
        ],
        backgroundColor: dashboardBarColor,
      ),
      body: CustomBackground(
        topColor: dashboardBarColor, 
        bottomColor: ternaryColor, 
        bottom: Container(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCircleAvatarButton(
                background: formBackgroundColor, 
                foreground: formForegroundColor, 
                radius: 100.0, 
                icon: Icons.add_a_photo,
                image: this._patient.photo,
              ),
              SizedBox(height: this.widget.spacingBetweenFields),
              CustomTextFormField(
                controller: this._nameFieldControl,
                fieldName: 'Nome',
                hintText: 'Nome Completo',
                prefixIcon: Icons.person,
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                onSaved: (name) => this._patient.name = name,
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
                      onSaved: (birthDate) => this._patient.birthDate = DateTime.parse(birthDate),
                    ),
                    CustomDateFormField(
                      controller: this._diagnosticFieldControl,
                      fieldName: 'Diagnóstico',
                      width: _halfMediaWidth,
                      hintText: 'Diagnóstico',
                      prefixIcon: Icons.medical_services, 
                      onSaved: (diagnosis) => this._patient.diagnosis = diagnosis,
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
                      controller: this._weightFieldControl,
                      fieldName: 'Peso',
                      width: _halfMediaWidth,
                      hintText: 'Peso',
                      prefixIcon: Icons.line_weight,
                      type: TextInputType.number,
                      inputFormatters: [new LengthLimitingTextInputFormatter(10)],
                      onSaved: (weight) => this._patient.weight = weight,
                    ),
                    CustomTextFormField(
                      controller: this._heightFieldControl,
                      fieldName: 'Altura',
                      width: _halfMediaWidth,
                      hintText: 'Altura',
                      prefixIcon: Icons.height,
                      type: TextInputType.number,
                      inputFormatters: [new LengthLimitingTextInputFormatter(10)],
                      onSaved: (height) => this._patient.height = height,
                    ),
                  ],
                ),
              ),
            ], 
          ),
        ),
        horizontalPadding: this.widget.horizontalPadding, 
        margin: 10.0
      ),
    );
  }
}