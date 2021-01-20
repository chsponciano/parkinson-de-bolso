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
  Text _dynamicTitle;
  TextField _searchField;
  Icon _malleableBarIcon;
  Widget _dynamicWidget;
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
    this._malleableBarIcon = Icon(Icons.search, color: primaryColorDashboardBar);
    this._dynamicWidget = this._getWidget(this._selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this._dynamicWidget = this._getWidget(this._selectedIndex);
    this._dynamicTitle = Text(navegationLabelItem[this._selectedIndex]);
    this._searchField = TextField(
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
        fontSize: 18.0
      ),
      onChanged: (value) => this._onItemChanged(value)
    );

    return Scaffold(
      appBar: AppBar(
        title: this._isSearchDisabled() ? this._dynamicTitle : this._searchField,
        backgroundColor: dashboardBarColor,
        actions: [
          if (this._selectedIndex == 0)
            IconButton(
              icon: this._malleableBarIcon, 
              onPressed: () => this.setState(() => this._malleableBarIcon = Icon(this._isSearchDisabled() ? Icons.cancel : Icons.search, color: primaryColorDashboardBar)),
            )          
        ]
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white10
        ),
        child: this._dynamicWidget,
      ),
      bottomNavigationBar: this._buildNavigationBar(),
      floatingActionButton: (this._selectedIndex == 0 && this._malleableBarIcon.icon == Icons.search) ? FloatingActionButton(
        onPressed: () => print('add patient'),
        child: Icon(
          Icons.add, 
          color: primaryColorDashboardBar,
          size: 40,
        ),
        backgroundColor: floatingButtonDashboard,
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }

  Widget _buildNavigationBar() {
    var items = <BottomNavigationBarItem>[];
    for (var i = 0; i < navegationLabelItem.length; i++) {
      items.add(BottomNavigationBarItem(
        label: navegationLabelItem[i],
        icon: Icon(navegationIconItem[i])
      ));
    }

    return BottomNavigationBar(
      items: items,
      backgroundColor: dashboardBarColor,
      unselectedItemColor: secondaryColorDashboardBar,
      currentIndex: _selectedIndex,
      selectedItemColor: primaryColorDashboardBar,
      onTap: (index) => {
        this.setState(() {
          this._selectedIndex = index;
        })
      },
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

  void _resetData(data) {
    this.setState(() => this._data = data);
    this._resetCache();
  }

  void _resetCache() {
    this.setState(() => this._cachedData = this._data);
  }

  bool _isSearchDisabled() => (this._malleableBarIcon.icon == Icons.search);
}