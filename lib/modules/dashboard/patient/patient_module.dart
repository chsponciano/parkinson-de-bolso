import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/dashboard_module.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/form/patient_form.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/viewer/patient_viewer.dart';
import 'package:parkinson_de_bolso/service/patient_service.dart';
import 'package:parkinson_de_bolso/widget/custom_list_search.dart';

class PatientModule extends StatefulWidget {
  PatientModule({ Key key }) : super(key: key);

  @override
  _PatientModuleState createState() => _PatientModuleState();  
}

class _PatientModuleState extends State<PatientModule> {
  List<PatientModel> _data = <PatientModel>[];
  bool _inSearch, _scrollingPage, _isAdd, _isEdit;
  PatientModel _selectedPatient;

  @override
  void initState() {
    this._inSearch = false;
    this._scrollingPage = false;
    this._isEdit = false;
    this._isAdd = false;
    this._selectedPatient = null;
    super.initState();
  }

  bool isNotDisplayAddButton() => (this._inSearch || this._scrollingPage || this._selectedPatient != null || this._isAdd);

  void changeSearchStatus() => this.setState(() => this._inSearch = !this._inSearch);

  void changeScrollStatus(bool status) => this.setState(() => this._scrollingPage = status);

  void selectPatient(SearchData searchModel) => this.setState(() => this._selectedPatient = searchModel);

  void resetWidgetStatus() => this.setState(() {
    this._isAdd = false;
    this._isEdit = false;
    this._selectedPatient = null;
  });
  
  void resetEditStatus(PatientModel patient) => this.setState(() {
    this._isEdit = false;
    this._selectedPatient = patient;
  });

  void enableEditing() => this.setState(() {
    this._isEdit = true;
  });

  void removeRecord() {
    this.setState(() {
      this._data.remove(this._selectedPatient);
    });
    this.resetWidgetStatus();
  }

  Widget getCurrentWidget() {
    if (this._isEdit) {
      return PatientForm(
        callHigher: this.resetEditStatus,
        patient: this._selectedPatient,
      );
    }

    if (this._selectedPatient != null) {
      return PatientViewer(
        callHigher: this.resetWidgetStatus,
        callEdition: this.enableEditing,
        callRemoval: this.removeRecord,
        patient: this._selectedPatient,
      );
    }

    if (this._isAdd) {
      return PatientForm(
        callHigher: this.resetWidgetStatus,
      );
    }

    return RefreshIndicator(
      onRefresh: reload,
      color: primaryColor,
      child: CustomListSearch(
        widgetName: 'Pacientes',
        barColor: dashboardBarColor,
        searchStatusController: this.changeSearchStatus,
        scrollStatusController: this.changeScrollStatus,
        onTap: this.selectPatient,
        future: PatientService.instance.getAll(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.getCurrentWidget(),
      floatingActionButton: this.isNotDisplayAddButton() ? null : FloatingActionButton(
        tooltip: 'Adicionar',
        onPressed: () => this.setState(() => this._isAdd = true),
        child: Icon(
          Icons.add, 
          color: primaryColorDashboardBar,
          size: 40,
        ),
        backgroundColor: floatingButtonDashboard,
      ),
    );
  }

  Future<void> reload() async {
    Navigator.pushReplacement(
      context, 
      PageRouteBuilder(
        pageBuilder: (a, b, c) => RouteHandler.instance.getRoute(DashboardModule.routeName), 
        transitionDuration: Duration(seconds:  0)
      )
    );
  }
}