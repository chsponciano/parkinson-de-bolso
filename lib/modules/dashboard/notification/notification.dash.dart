import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/notification.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/receivedNotification.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/executation.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/search.patient.dash.dart';
import 'package:parkinson_de_bolso/service/notify.service.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/widget/circularProgress.widget.dart';

class NotificationDash extends StatefulWidget {
  static const String routeName = '/notification';
  final bool externalCall;
  final String payload;

  const NotificationDash({
    Key key,
    this.payload,
    this.externalCall = false,
  }) : super(key: key);

  @override
  _NotificationDashState createState() => _NotificationDashState();

  BuildContext getContext() => createState()?.context;
}

class _NotificationDashState extends State<NotificationDash> {
  ScrollController _scrollController;
  List<ReceivedNotificationModel> data;

  @override
  void initState() {
    this._scrollController = ScrollController();
    super.initState();
  }

  Widget _buildCard(int index, ReceivedNotificationModel notification) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.chat),
            title: Text(notification.title),
            subtitle: Text(notification.body),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (notification.payload == 'classification')
                TextButton(
                  child: Text('VER RESULTADOS'),
                  onPressed: () {
                    AppConfig.instance.changeModule(ModuleType.DASHBOARD);
                    NotifyService.instance.markRead(notification);
                    Navigator.pushNamed(
                        context, ExecutationPatientDash.routeName, arguments: {
                      'id': notification.additional,
                      'externalCall': 0
                    });
                  },
                ),
              TextButton(
                child: const Text('MARCA COMO LIDO'),
                onPressed: () {
                  if (NotifyService.instance.markRead(notification) != null) {
                    Future.delayed(Duration(seconds: 1), this.reload);
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            (this.widget.externalCall)
                ? Navigator.pushNamed(context, SearchPatientDash.routeName)
                : Navigator.pop(context);
            AppConfig.instance.changeModule(
              ModuleType.DASHBOARD,
            );
            NotificationConfig.instance.getNewNotifications();
          },
        ),
        centerTitle: true,
        backgroundColor: ThemeConfig.dashboardBarColor,
        title: Text('Notificações'),
      ),
      body: RefreshIndicator(
        onRefresh: this.reload,
        color: ThemeConfig.primaryColor,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(top: 10),
                                child: FutureBuilder(
                                  future: NotifyService.instance.getAll(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      this.data = snapshot.data;
                                      return (data.length > 0)
                                          ? ListView.builder(
                                              controller:
                                                  this._scrollController,
                                              shrinkWrap: true,
                                              itemCount: data.length,
                                              itemBuilder: (context, index) {
                                                return this._buildCard(
                                                    index, data[index]);
                                              },
                                            )
                                          : Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.chat,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    'Sem notificações',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                    } else {
                                      return CircularProgressWidget(
                                        valueColor: ThemeConfig.primaryColor,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> reload() async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (a, b, c) => NotificationDash(),
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }
}
