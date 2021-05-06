import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/appBarButton.model.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/camera/camera.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/patient/patient.form.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/patient/patient.main.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/report/report.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/setting/setting.page.dart';
import 'package:parkinson_de_bolso/route/dashboard.route.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/type/patient.internal.type.dart';

class DashboardActions {
  DashboardActions._privateConstructor();
  static final DashboardActions instance =
      DashboardActions._privateConstructor();
  final AppConfig _appConfig = AppConfig.instance;
  Function _openNavegationPageFunction;
  Function _onItemChangedFunction;
  Function _onChangeInternalPagePatientFunction;
  Function _onDeleteFunction;
  Function _onSearchStatusFunction;
  Function _onActiveNavegationFunction;
  PatientInternalType _returnPatientType;
  BuildContext _context;
  PatientModel _patient;

  setOnItemChangedFunction(Function f) {
    this._onItemChangedFunction = f;
  }

  setOnChangeInternalPagePatientFunction(Function f) {
    this._onChangeInternalPagePatientFunction = f;
  }

  setOnDeleteFunction(Function f) {
    this._onDeleteFunction = f;
  }

  setOnSearchStatusFunction(Function f) {
    this._onSearchStatusFunction = f;
  }

  setReturnPatientType(PatientInternalType t) {
    this._returnPatientType = t;
  }

  setOpenNavegationPageFunction(Function f) {
    this._openNavegationPageFunction = f;
  }

  callOpenNavegationPageFunction() {
    this._appConfig.changeModule(ModuleType.NOTIFICATION, null, [], null);
    this._openNavegationPageFunction();
  }

  onRelocateInnerPage() {
    switch (this._returnPatientType) {
      case PatientInternalType.CHANGE:
        this.setPatientFormChangeRoute();
        break;
      case PatientInternalType.CREATE:
        this.setPatientFormCreateRoute();
        break;
      case PatientInternalType.VIEW:
      default:
        this.setPatientViewRoute();
        break;
    }
  }

  setPatientListRoute() {
    this._appConfig.changeModule(
          ModuleType.DASHBOARD,
          Text(
            PatientMainPage.name,
          ),
          [
            AppBarButtonModel(
              icon: Icon(Icons.search),
              action: setPatientSearchRoute,
            ),
          ],
          null,
        );
    this._onChangeInternalPagePatientFunction(PatientInternalType.LIST);
  }

  setPatientFormCreateRoute() {
    this._appConfig.changeModule(
          ModuleType.DASHBOARD,
          Text(
            PatientFormPage.creationFormName,
          ),
          [],
          this._buildBackButtonPatientList(),
        );

    this._onChangeInternalPagePatientFunction(PatientInternalType.CREATE);
  }

  setPatientFormChangeRoute() {
    this._appConfig.changeModule(
          ModuleType.DASHBOARD,
          Text(
            PatientFormPage.changeFormName,
          ),
          [],
          this._buildBackButtonPatientView(),
        );

    this._onChangeInternalPagePatientFunction(PatientInternalType.CHANGE);
  }

  setPatientSearchRoute() {
    final FocusNode focusNode = new FocusNode();
    this._appConfig.changeModule(
          ModuleType.DASHBOARD,
          TextField(
            focusNode: focusNode,
            autofocus: true,
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              fillColor: Colors.red,
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              hintText: 'Pesquisar',
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
            onChanged: (value) => this._onItemChangedFunction(value),
          ),
          [
            AppBarButtonModel(
              icon: Icon(Icons.close),
              action: () {
                this._onActiveNavegationFunction(true);
                this._onSearchStatusFunction(false);
                this._onItemChangedFunction('');
                this.setPatientListRoute();
              },
            ),
          ],
          null,
        );
    this._onSearchStatusFunction(true);
    this._onActiveNavegationFunction(false);
    focusNode.requestFocus();
  }

  setPatientViewRoute() {
    this._appConfig.changeModule(
          ModuleType.DASHBOARD,
          null,
          [
            AppBarButtonModel(
              icon: Icon(Icons.video_call),
              action: () async {
                this._appConfig.changeModule(ModuleType.CAMERA, null, [], null);
                await CameraPage.processImageSequence(
                  this._context,
                  this._patient,
                );
              },
            ),
            AppBarButtonModel(
              icon: Icon(Icons.edit),
              action: this.setPatientFormChangeRoute,
            ),
            AppBarButtonModel(
              icon: Icon(Icons.delete),
              action: () {
                this._onDeleteFunction();
                this.setPatientListRoute();
              },
            ),
          ],
          this._buildBackButtonPatientList(),
        );

    this._onChangeInternalPagePatientFunction(PatientInternalType.VIEW);
  }

  setReportRoute() {
    this._appConfig.changeModule(
          ModuleType.DASHBOARD,
          Text(
            ReportPage.name,
          ),
          [],
          null,
        );
  }

  setSettingRoute() {
    this._appConfig.changeModule(
          ModuleType.DASHBOARD,
          Text(
            SettingPage.name,
          ),
          [
            AppBarButtonModel(
              icon: Icon(
                Icons.logout,
                color: ThemeConfig.ternaryColor,
              ),
              action: DashboardRoutes.instance.logout,
            ),
          ],
          null,
        );
  }

  IconButton _buildBackButtonPatientList() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: this.setPatientListRoute,
    );
  }

  IconButton _buildBackButtonPatientView() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        this._onChangeInternalPagePatientFunction(
          PatientInternalType.VIEW,
        );
        this.setPatientViewRoute();
      },
    );
  }

  setAttibuteProcessImageSequence(
    BuildContext context,
    PatientModel patient,
  ) {
    this._context = context;
    this._patient = patient;
  }

  setOnActiveNavegationFunction(Function f) {
    this._onActiveNavegationFunction = f;
  }

  reset() {
    if (this._onActiveNavegationFunction != null) {
      this._onActiveNavegationFunction(true);
    }
    if (this._onSearchStatusFunction != null) {
      this._onSearchStatusFunction(false);
    }
  }
}
