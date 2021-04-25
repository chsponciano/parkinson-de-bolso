import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/interface/search.interface.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
import 'package:parkinson_de_bolso/util/string.util.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';
import 'package:parkinson_de_bolso/widget/custom_circular_progress.dart';
import 'package:parkinson_de_bolso/widget/custom_no_data.dart';

class CustomListSearch extends StatefulWidget {
  final String widgetName;
  final Color barColor;
  final Function scrollStatusController;
  final Function onTap;
  final List<IconButton> actions;
  final Future future;

  CustomListSearch(
      {@required this.widgetName,
      @required this.barColor,
      @required this.scrollStatusController,
      @required this.onTap,
      this.actions,
      @required this.future});

  @override
  _CustomListSearchState createState() => _CustomListSearchState();
}

class _CustomListSearchState extends State<CustomListSearch> with StringUtil {
  List<SearchData> _data, _cachedData;
  ScrollController _scrollController;

  @override
  void initState() {
    this._data = <SearchData>[];
    this._scrollController = ScrollController();
    this._scrollController.addListener(
      () {
        this.widget.scrollStatusController(
              this._scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse,
            );
      },
    );
    DashboardActions.instance.setOnItemChangedFunction(this._onItemChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        margin: 10.0,
        topColor: ThemeConfig.dashboardBarColor,
        bottomColor: ThemeConfig.ternaryColor,
        bottom: Container(
          child: this.getData(),
        ),
        horizontalPadding: 10.0);
  }

  Widget getData() {
    return FutureBuilder(
      future: this.widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          this._data = snapshot.data;
          this._data.sort(
                (a, b) => a.searchText().toLowerCase().compareTo(
                      b.searchText().toLowerCase(),
                    ),
              );

          if (this._data.length == 0)
            return CustomNoData(
              image: AppConfig.instance.assetConfig.get('noDataPatient'),
            );

          return ListView.builder(
              controller: this._scrollController,
              shrinkWrap: true,
              itemCount: (this._cachedData != null)
                  ? this._cachedData.length
                  : this._data.length,
              itemBuilder: (context, index) {
                return this._buildPatientCard(((this._cachedData != null)
                    ? this._cachedData
                    : this._data)[index]);
              });
        } else {
          return CustomCircularProgress(
            valueColor: ThemeConfig.primaryColor,
          );
        }
      },
    );
  }

  Widget _buildPatientCard(PatientModel patient) {
    return ListTile(
      onTap: () => this.widget.onTap(patient),
      title: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: ThemeConfig.secondaryColorDashboardBar,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomCircleAvatar(
              radius: 20,
              background: ThemeConfig.secondaryColor,
              foreground: ThemeConfig.ternaryColor,
              imagePath: patient.imageUrl,
            ),
            Text(
              patient.fullname.length > 25
                  ? this.abbreviate(
                      patient.fullname,
                    )
                  : patient.fullname,
              style: TextStyle(
                color: ThemeConfig.primaryColor,
                fontSize: 18.0,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }

  void _onItemChanged(String query) {
    if (query.length > 1 && query.isNotEmpty) {
      var result = this
          ._data
          .where(
            (element) => removeDiacritics(
              element.searchText(),
            ).toLowerCase().contains(
                  removeDiacritics(
                    query.toString(),
                  ).toLowerCase(),
                ),
          )
          .toList();
      setState(() {
        this._cachedData = result;
      });
    } else {
      setState(() {
        this._cachedData?.clear();
        this._cachedData?.addAll(
              this._data,
            );
      });
    }
  }
}
