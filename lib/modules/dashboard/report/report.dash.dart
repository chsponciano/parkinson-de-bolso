import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/report.model.dart';
import 'package:parkinson_de_bolso/service/report.service.dart';
import 'package:parkinson_de_bolso/widget/circularProgress.widget.dart';

class ReportDash extends StatefulWidget {
  static const String routeName = '/report';

  @override
  _ReportDashState createState() => _ReportDashState();
}

class _ReportDashState extends State<ReportDash> {
  @override
  void didChangeDependencies() {
    DashConfig.instance.setContext(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => DashConfig.instance.setBarAttributes(
        null,
        Text('Relatórios'),
        null,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ReportService.instance.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ReportModel> reports = snapshot.data;
          return this._buildReportsList(reports);
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

  Widget _buildReportsList(List<ReportModel> reports) {
    if (reports.length == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics,
              size: 50,
              color: Colors.grey,
            ),
            Text(
              'Relatórios indisponiveis',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            )
          ],
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          return this._buildReportCard(reports[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   IconData(
            //     report.icon,
            //     fontFamily: 'MaterialIcons',
            //   ),
            //   color: ThemeConfig.primaryColor,
            // ),
            SizedBox(
              width: 10,
            ),
            Text(
              report.name,
              style: TextStyle(
                color: ThemeConfig.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
