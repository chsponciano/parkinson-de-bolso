import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/adapter/dialog.adapter.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/search.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/view.patient.dash.dart';
import 'package:parkinson_de_bolso/service/patient.service.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/widget/circleAvatarButton.widget.dart';
import 'package:parkinson_de_bolso/widget/circularProgress.widget.dart';
import 'package:parkinson_de_bolso/widget/dateFormField.widget.dart';
import 'package:parkinson_de_bolso/widget/textFormField.widget.dart';

class FormPatientDash extends StatefulWidget {
  static const String routeName = '/patientForm';
  final PatientModel patient;
  final double distance;

  const FormPatientDash({
    Key key,
    this.patient,
    this.distance = 15,
  }) : super(key: key);

  @override
  _FormPatientDashState createState() => _FormPatientDashState();
}

class _FormPatientDashState extends State<FormPatientDash> with DateTimeUtil {
  GlobalKey<FormState> _formState;
  DateFormat _dateFormat;
  DialogAdapter _dialogAdapter;
  bool _loading;

  // Text editing controller
  TextEditingController _nameFieldControl;
  TextEditingController _birthdayFieldControl;
  TextEditingController _diagnosticFieldControl;
  TextEditingController _weightFieldControl;
  TextEditingController _heightFieldControl;

  // Focus nodes
  FocusNode _nameFocus;
  FocusNode _weightFocus;
  FocusNode _heightFocus;

  // Patient data
  PatientModel _patient;
  String _id;

  @override
  void initState() {
    this._formState = GlobalKey<FormState>();
    this._dateFormat = DateFormat('dd/MM/yyyy');
    this._dialogAdapter = DialogAdapter.instance;
    this._loading = false;
    this._nameFocus = FocusNode();
    this._weightFocus = FocusNode();
    this._heightFocus = FocusNode();
    this._initializePatientData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    DashConfig.instance.setContext(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DashConfig.instance.setBarAttributes(
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(
              context,
              (this._patient.id == null)
                  ? SearchPatientDash.routeName
                  : ViewPatientDash.routeName,
              arguments: {
                'patient': this._patient,
              },
            ),
          ),
          Text((this._patient.id != null)
              ? 'Alterar Paciente'
              : 'Adicionar Paciente'),
          null);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _halfMediaWidth = (MediaQuery.of(context).size.width / 2.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Form(
                          key: this._formState,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatarButtonWidget(
                                background: ThemeConfig.formBackgroundColor,
                                foreground: ThemeConfig.formForegroundColor,
                                radius: 100.0,
                                icon: Icons.add_a_photo,
                                image: this._patient.image,
                                imageUrl: this._patient.imageUrl,
                                setImage: (image) {
                                  this.setState(
                                    () {
                                      this._patient.image = image;
                                      this._patient.imageUrl = null;
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                height: this.widget.distance,
                              ),
                              TextFormFieldWidget(
                                focusNode: this._nameFocus,
                                controller: this._nameFieldControl,
                                fieldName: 'Nome',
                                hintText: 'Nome Completo',
                                prefixIcon: Icons.person,
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(30)
                                ],
                                onSaved: (name) =>
                                    this._patient.fullname = name,
                              ),
                              SizedBox(
                                height: this.widget.distance,
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DateFormFieldWidget(
                                      controller: this._birthdayFieldControl,
                                      fieldName: 'Nascimento',
                                      width: _halfMediaWidth,
                                      hintText: 'Nascimento',
                                      prefixIcon: Icons.calendar_today,
                                      onSaved: (birthdate) => this
                                          ._patient
                                          .birthdate = this.strToDate(
                                        birthdate,
                                        DateTimeFormatUtil.BR_DATE,
                                      ),
                                      focusNode: [
                                        this._heightFocus,
                                        this._weightFocus,
                                        this._nameFocus
                                      ],
                                    ),
                                    DateFormFieldWidget(
                                      controller: this._diagnosticFieldControl,
                                      fieldName: 'Diagnóstico',
                                      width: _halfMediaWidth,
                                      hintText: 'Diagnóstico',
                                      prefixIcon: Icons.medical_services,
                                      onSaved: (diagnosis) => this
                                          ._patient
                                          .diagnosis = this.strToDate(
                                        diagnosis,
                                        DateTimeFormatUtil.BR_DATE,
                                      ),
                                      focusNode: [
                                        this._heightFocus,
                                        this._weightFocus,
                                        this._nameFocus
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: this.widget.distance,
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormFieldWidget(
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
                                      onSaved: (weight) =>
                                          this._patient.weight = weight,
                                    ),
                                    TextFormFieldWidget(
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
                                      onSaved: (height) =>
                                          this._patient.height = height,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: this.widget.distance,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    color: ThemeConfig.primaryColor,
                                    textColor: ThemeConfig.ternaryColor,
                                    child: Text(
                                      (this.widget.patient != null)
                                          ? 'Alterar'
                                          : 'Criar',
                                    ),
                                    onPressed: this._submit,
                                  ),
                                  SizedBox(
                                    width: this.widget.distance * 2,
                                  ),
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
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: this._loading,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                  ),
                  child: Center(
                    child: CircularProgressWidget(
                      valueColor: ThemeConfig.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _initializePatientData() {
    this._nameFieldControl = TextEditingController();
    this._birthdayFieldControl = TextEditingController();
    this._diagnosticFieldControl = TextEditingController();
    this._weightFieldControl = TextEditingController();
    this._heightFieldControl = TextEditingController();

    if (this.widget.patient == null) {
      this._patient = PatientModel();
    } else {
      this._patient = this.widget.patient.clone();
      this._id = this.widget.patient.id;
      this._nameFieldControl.text = this._patient.fullname;
      this._birthdayFieldControl.text = this._dateFormat.format(
            this._patient.birthdate,
          );
      this._diagnosticFieldControl.text = this._dateFormat.format(
            this._patient.diagnosis,
          );
      this._weightFieldControl.text = this._patient.weight.toString();
      this._heightFieldControl.text = this._patient.height.toString();
    }
  }

  _submit() {
    if (this._formState.currentState.validate()) {
      this._formState.currentState.save();
      (this.widget.patient != null) ? this._update() : this._create();
    }
  }

  _reset() {
    setState(() {
      this._patient = PatientModel();
      this._nameFieldControl.clear();
      this._birthdayFieldControl.clear();
      this._diagnosticFieldControl.clear();
      this._weightFieldControl.clear();
      this._heightFieldControl.clear();
    });
  }

  _create() {
    this.setState(() => this._loading = true);
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
    }).whenComplete(() => this.setState(() => this._loading = false));
  }

  _update() {
    this.setState(() => this._loading = true);
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
    }).whenComplete(() => this.setState(() => this._loading = false));
  }
}
