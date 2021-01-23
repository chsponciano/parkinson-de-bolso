import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/util/snackbar_util.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PatientModel _patient;

  @override
  void initState() {
    this._patient = (this.widget.patient != null) ? this.widget.patient : PatientModel();
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
        title: Text('Adicionar Paciente'),
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: this.widget.horizontalPadding, vertical: 50),
          child: Form(
            key: this._formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCircleAvatarButton(
                    background: formBackgroundColor, 
                    foreground: formForegroundColor, 
                    radius: 100.0, 
                    icon: Icons.add_a_photo
                  ),
                  SizedBox(height: this.widget.spacingBetweenFields),
                  CustomTextFormField(
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
                          fieldName: 'Nascimento',
                          width: _halfMediaWidth,
                          hintText: 'Nascimento',
                          prefixIcon: Icons.calendar_today, 
                          onSaved: (birthDate) => this._patient.birthDate = DateTime.parse(birthDate),
                        ),
                        CustomDateFormField(
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
                          fieldName: 'Peso',
                          width: _halfMediaWidth,
                          hintText: 'Peso',
                          prefixIcon: Icons.line_weight,
                          type: TextInputType.number,
                          inputFormatters: [new LengthLimitingTextInputFormatter(10)],
                          onSaved: (weight) => this._patient.weight = weight,
                        ),
                        CustomTextFormField(
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
          )
        ),
      ),
    );
  }
}