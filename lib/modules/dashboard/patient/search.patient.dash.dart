import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/interface/search.interface.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/form.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/view.patient.dash.dart';
import 'package:parkinson_de_bolso/service/patient.service.dart';
import 'package:parkinson_de_bolso/util/string.util.dart';
import 'package:parkinson_de_bolso/widget/circleAvatar.widget.dart';
import 'package:parkinson_de_bolso/widget/circularProgress.widget.dart';
import 'package:parkinson_de_bolso/widget/noData.widget.dart';

class SearchPatientDash extends StatefulWidget {
  static const String routeName = '/';

  @override
  _SearchPatientDashState createState() => _SearchPatientDashState();
}

class _SearchPatientDashState extends State<SearchPatientDash> with StringUtil {
  List<SearchData> _data, _cachedData;
  bool _inSearch, _scrollingPage;
  ScrollController _scrollController;
  FocusNode _textFieldFocusNode;

  @override
  void initState() {
    this._data = <SearchData>[];
    this._scrollingPage = false;
    this._scrollController = ScrollController();
    this._scrollController.addListener(
          () => this.setState(
            () => this._scrollingPage =
                this._scrollController.position.userScrollDirection ==
                    ScrollDirection.reverse,
          ),
        );
    this._inSearch = false;
    this._textFieldFocusNode = new FocusNode();
    this._textFieldFocusNode.addListener(
          () => this.setState(
            () => this._inSearch = this._textFieldFocusNode.hasFocus,
          ),
        );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    DashConfig.instance.setContext(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DashConfig.instance.setBarAttributes(null, Text('Pacientes'), null);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: RefreshIndicator(
          onRefresh: this._reload,
          color: ThemeConfig.primaryColor,
          child: Scaffold(
            body: this._buildContent(),
            floatingActionButton: !this._scrollingPage && !this._inSearch
                ? FloatingActionButton(
                    tooltip: 'Adicionar',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      FormPatientDash.routeName,
                    ),
                    child: Icon(
                      Icons.add,
                      color: ThemeConfig.primaryColorDashboardBar,
                      size: 40,
                    ),
                    backgroundColor: ThemeConfig.floatingButtonDashboard,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSerchBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: TextField(
        focusNode: this._textFieldFocusNode,
        // autofocus: true,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          filled: true,
          fillColor: ThemeConfig.primaryColor,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          hintText: 'Pesquisar',
          focusedBorder: UnderlineInputBorder(
            borderRadius: new BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: new BorderRadius.circular(10),
          ),
          suffixIcon: Icon(
            Icons.search,
            color: ThemeConfig.ternaryColor,
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),

        onChanged: (value) => this._onItemChanged(value),
      ),
    );
  }

  Widget _buildPatientCard(PatientModel patient) {
    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        ViewPatientDash.routeName,
        arguments: {
          'patient': patient,
        },
      ),
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
            CircleAvatarWidget(
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

  Widget _buildContent() {
    return FutureBuilder(
      future: PatientService.instance.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          this._data = snapshot.data;
          this._data.sort(
                (a, b) => a.searchText().toLowerCase().compareTo(
                      b.searchText().toLowerCase(),
                    ),
              );

          if (this._data.length == 0)
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: NoDataWidget(
                  image: AppConfig.instance.assetConfig.get('noDataPatient'),
                ),
              ),
            );

          return Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    this._buildSerchBar(),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: ListView.builder(
                            controller: this._scrollController,
                            shrinkWrap: true,
                            itemCount: (this._cachedData != null)
                                ? this._cachedData.length
                                : this._data.length,
                            itemBuilder: (context, index) {
                              return this._buildPatientCard(
                                  ((this._cachedData != null)
                                      ? this._cachedData
                                      : this._data)[index]);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Container(
              child: CircularProgressWidget(
                valueColor: ThemeConfig.primaryColor,
              ),
            ),
          );
        }
      },
    );
  }

  void _onItemChanged(String query) {
    if (query.length > 0 && query.isNotEmpty) {
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

  Future<void> _reload() async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (a, b, c) => SearchPatientDash(),
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }
}
