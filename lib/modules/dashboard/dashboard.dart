import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/patient_list.dart';
import 'package:parkinson_de_bolso/service/service_patient.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = '/dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<SearchModel> _data = <SearchModel>[];
  List<SearchModel> _cachedData = <SearchModel>[];
  Widget _malleableWidget;
  Icon _malleableIcon;
  int _selectedIndex = 0;

  Widget _getWidget(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = PatientList(cachedData: this._cachedData);
        this._resetData(ServicePatient.instance.getAllPatient());
        break;
      case 1:
        screen = Text(
          'Index 1: Report',
        );
        break;
      case 2:
        screen = Text(
          'Index 2: Setting',
        );
        break;
    }
    return screen;
  }

  @override
  void initState() {
    this._buildTextTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: this._malleableWidget,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: this._malleableIcon, 
            onPressed: () {
              if (this._malleableIcon.icon == Icons.search) {
                this._buildSearchField();
              } else {
                this._buildTextTitle();
              }
            },
          )          
        ]
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white10
        ),
        child: this._getWidget(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: (index) => {
          this.setState(() {
            this._selectedIndex = index;
          })
        },
      ),
    );
  }

  void _onItemChanged(String query) {
    if (query.isNotEmpty) {
      this.setState(() {
        this._cachedData = this._data
            .where((element) => removeDiacritics(element.searchText()).toLowerCase().contains(removeDiacritics(query.toString()).toLowerCase()))
            .toList();
      });
    } else {
      this._resetCache();
    }
  }

  void _buildTextTitle() {
    this.setState(() {
      this._malleableIcon = Icon(Icons.search, color: ternaryColor);
      this._malleableWidget = Text('Dashboard', style: TextStyle(color: ternaryColor));
    });
  }

  void _buildSearchField() {
    this.setState(() {
      this._malleableIcon = Icon(Icons.cancel);
      this._malleableWidget = TextField(
        autofocus: true,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.white
          ),
          hintText: 'Buscar'
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0
        ),
        onChanged: (value) => this._onItemChanged(value)
      );
    });
  }

  void _resetData(data) {
    this.setState(() => this._data = data);
    this._resetCache();
  }

  void _resetCache() {
    this.setState(() => this._cachedData = this._data);
  }
}