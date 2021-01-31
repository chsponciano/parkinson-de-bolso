import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/service/patient_service.dart';
import 'package:parkinson_de_bolso/util/datetime_util.dart';
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

class _PatientFormState extends State<PatientForm> with SnackbarUtil, DateTimeUtil {
  final _format = DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldControl = TextEditingController();
  final TextEditingController _birthdayFieldControl = TextEditingController();
  final TextEditingController _diagnosticFieldControl = TextEditingController();
  final TextEditingController _weightFieldControl = TextEditingController();
  final TextEditingController _heightFieldControl = TextEditingController();
  var loading;
  PatientModel _patient;

  @override
  void initState() {
    if (this.widget.patient != null) {
      this._patient = this.widget.patient;
      this._nameFieldControl.text = this._patient.name;
      this._birthdayFieldControl.text = this._format.format(this._patient.birthdate);
      this._diagnosticFieldControl.text = this._format.format(this._patient.diagnosis);
      this._weightFieldControl.text = this._patient.weight.toString();
      this._heightFieldControl.text = this._patient.height.toString();
    } else {
      this._patient = PatientModel();
    }
    this.loading = false;
    super.initState();
  }

  void callAlert(String message, SnackbarType type) {
    this.showSnackbar(this._scaffoldKey, message, type);
    this.setState(() => this.loading = false);
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

  void _submit() async {
    if (!this._formKey.currentState.validate()) {
      this.callAlert('Formulário inválido!  Por favor, preencher os campos.', SnackbarType.ERROR);
    } else {
      this.setState(() => this.loading = true);
      this._formKey.currentState.save();
      Future<dynamic> future = (this.widget.patient == null) ? PatientService.instance.create(this._patient) : PatientService.instance.update(this._patient);

      future.then((value) {
        var message = '';
        
        if (this.widget.patient == null) {
          this._reset();
          message = 'Paciente ' + value.name.split(' ')[0] + ' adicionado com sucesso!';
        } else {
          this._patient = value;
          message = 'Paciente ' + this._patient.name.split(' ')[0] + ' alterado com sucesso!';
        }

        this.callAlert(message, SnackbarType.SUCESS);
      }).catchError((err) {
        this.callAlert('Error: ' + err.toString().substring(0, 30) + '...', SnackbarType.ERROR);
      });
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
          tooltip: 'Voltar',
          icon: Icon(
            Icons.arrow_back_sharp, 
            color: primaryColorDashboardBar
          ),
          onPressed: () => this.widget.callHigher.call(),
        ),
        actions: [
          IconButton(
            tooltip: 'Salvar',
            icon: Icon(
              Icons.save, color: 
              primaryColorDashboardBar
            ),
            onPressed: () => this._submit(),
          ),
        ],
        backgroundColor: dashboardBarColor,
      ),
      body: CustomBackground(
        topColor: dashboardBarColor, 
        bottomColor: ternaryColor, 
        loading: this.loading,
        bottom: Container(
          padding: EdgeInsets.only(top: 30),
          child: Form(
            key: this._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCircleAvatarButton(
                  background: formBackgroundColor, 
                  foreground: formForegroundColor, 
                  radius: 100.0, 
                  icon: Icons.add_a_photo,
                  image: this._patient.image,
                  imageUrl: this._patient.imageUrl,
                  setImage: (image) {
                    this.setState(() {
                      this._patient.image = image;
                    });
                  },
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
                        onSaved: (birthdate) => this._patient.birthdate = this.strToDate(birthdate, DateTimeFormatUtil.BR_DATE),
                      ),
                      CustomDateFormField(
                        controller: this._diagnosticFieldControl,
                        fieldName: 'Diagnóstico',
                        width: _halfMediaWidth,
                        hintText: 'Diagnóstico',
                        prefixIcon: Icons.medical_services, 
                        onSaved: (diagnosis) => this._patient.diagnosis = this.strToDate(diagnosis, DateTimeFormatUtil.BR_DATE),
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
                        onSaved: (weight) => this._patient.weight = double.parse(weight),
                      ),
                      CustomTextFormField(
                        controller: this._heightFieldControl,
                        fieldName: 'Altura',
                        width: _halfMediaWidth,
                        hintText: 'Altura',
                        prefixIcon: Icons.height,
                        type: TextInputType.number,
                        inputFormatters: [new LengthLimitingTextInputFormatter(10)],
                        onSaved: (height) => this._patient.height = double.parse(height),
                      ),
                    ],
                  ),
                ),
              ], 
            ),
          ),
        ),
        horizontalPadding: this.widget.horizontalPadding, 
        margin: 10.0
      ),
    );
  }
}