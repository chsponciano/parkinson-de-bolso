import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
import 'package:parkinson_de_bolso/modules/dashboard/navagation/dashboard.navegation.dart';
import 'package:parkinson_de_bolso/modules/dashboard/notification/notification.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/patient/patient.form.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/patient/patient.viewer.page.dart';
import 'package:parkinson_de_bolso/service/patient.service.dart';
import 'package:parkinson_de_bolso/type/patient.internal.type.dart';
import 'package:parkinson_de_bolso/widget/custom_list_search.dart';

class PatientMainPage extends StatefulWidget {
  static final String name = 'Pacientes';

  PatientMainPage({Key key}) : super(key: key);

  @override
  _PatientMainPageState createState() => _PatientMainPageState();
}

class _PatientMainPageState extends State<PatientMainPage> {
  final DashboardActions _dashboardActions = DashboardActions.instance;
  PatientInternalType _internalType;

  List<PatientModel> _data = <PatientModel>[];
  bool _inSearch, _scrollingPage;
  PatientModel _selected;

  @override
  void initState() {
    this._inSearch = false;
    this._scrollingPage = false;
    this._selected = null;
    this._internalType = PatientInternalType.LIST;
    this._dashboardActions.setOnChangeInternalPagePatientFunction(
          this._changeInternalPage,
        );
    this._dashboardActions.setOnDeleteFunction(this._onRemovePatient);
    this._dashboardActions.setOnSearchStatusFunction(this._changeSearchStatus);
    this._dashboardActions.setOpenNavegationPageFunction(
          () => Navigator.pushNamed(
            context,
            NotificationPage.routeName,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._selectInternalPage(this._internalType),
      floatingActionButton: !this._scrollingPage &&
              !this._inSearch &&
              this._internalType == PatientInternalType.LIST
          ? FloatingActionButton(
              tooltip: 'Adicionar',
              onPressed: this._dashboardActions.setPatientFormCreateRoute,
              child: Icon(
                Icons.add,
                color: ThemeConfig.primaryColorDashboardBar,
                size: 40,
              ),
              backgroundColor: ThemeConfig.floatingButtonDashboard,
            )
          : null,
    );
  }

  Future<void> reload() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (a, b, c) => DashboardNavegation(),
            transitionDuration: Duration(seconds: 0)));
  }

  _selectInternalPage(PatientInternalType internalType) {
    this._dashboardActions.setReturnPatientType(internalType);

    switch (internalType) {
      case PatientInternalType.VIEW:
        return PatientViewerPage(
          patient: this._selected,
        );
      case PatientInternalType.CHANGE:
        return PatientFormPage(
          patient: this._selected,
        );
        break;
      case PatientInternalType.CREATE:
        return PatientFormPage();
      case PatientInternalType.LIST:
      default:
        return this._patientSearch();
    }
  }

  _patientSearch() {
    return RefreshIndicator(
      onRefresh: reload,
      color: ThemeConfig.primaryColor,
      child: CustomListSearch(
        widgetName: 'Pacientes',
        barColor: ThemeConfig.dashboardBarColor,
        scrollStatusController: this._changeScrollStatus,
        onTap: this._selectPatient,
        future: PatientService.instance.getAll(),
      ),
    );
  }

  _changeInternalPage(PatientInternalType internalType) {
    this.setState(() => this._internalType = internalType);
  }

  _changeSearchStatus(bool status) {
    this.setState(() => this._inSearch = status);
  }

  _changeScrollStatus(bool status) {
    this.setState(() => this._scrollingPage = status);
  }

  _selectPatient(PatientModel patient) {
    this.setState(() => this._selected = patient);
    this._dashboardActions.setPatientViewRoute();
  }

  _onRemovePatient() {
    PatientService.instance
        .delete(
          this._selected.id,
        )
        .then(
          (_) => this.setState(
            () => this._data.remove(
                  this._selected,
                ),
          ),
        );
  }
}
