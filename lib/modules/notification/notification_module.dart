import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/model/received_notification_model.dart';
import 'package:parkinson_de_bolso/service/notify_service.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circular_progress.dart';

class NotificationModule extends StatefulWidget {
  static const String routeName = '/notification';
  final String payload;

  const NotificationModule({Key key, this.payload}) : super(key: key);

  @override
  _NotificationModuleState createState() => _NotificationModuleState();

  BuildContext getContext() => createState()?.context;
}

class _NotificationModuleState extends State<NotificationModule> {
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
                  onPressed: () {/* ... */},
                ),
              TextButton(
                child: const Text('MARCA COMO LIDO'),
                onPressed: () {
                  if (NotifyService.instance.markRead(notification) != null) {
                    this.reload();
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
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: ThemeConfig.dashboardBarColor,
          title: Text('Notificações'),
        ),
        body: RefreshIndicator(
          onRefresh: this.reload,
          color: ThemeConfig.primaryColor,
          child: CustomBackground(
              margin: 10.0,
              topColor: ThemeConfig.dashboardBarColor,
              bottomColor: ThemeConfig.ternaryColor,
              bottom: Container(
                padding: EdgeInsets.only(top: 10),
                child: FutureBuilder(
                  future: NotifyService.instance.getAll(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      this.data = snapshot.data;
                      return (data.length > 0)
                          ? ListView.builder(
                              controller: this._scrollController,
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return this._buildCard(index, data[index]);
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                      return CustomCircularProgress(
                        valueColor: ThemeConfig.primaryColor,
                      );
                    }
                  },
                ),
              ),
              horizontalPadding: 10.0),
        ));
  }

  Future<void> reload() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (a, b, c) =>
                RouteConfig.instance.getRoute(NotificationModule.routeName),
            transitionDuration: Duration(seconds: 0)));
  }
}
