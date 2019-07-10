import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/dashboard/dashboard_presenter.dart';

class DashboardScreen extends BaseScreen {
  DashboardScreen(AppListener appListener) : super(appListener);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState
    extends BaseScreenState<DashboardScreen, DashboardPresenter> {
  @override
  Widget buildBody() {
    return Container(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                    ),
                    color: Colors.white,
                    iconSize: 42,
                    onPressed: () {
                      widget.appListener.router.navigateTo(
                        context,
                        Screens.NOTIFICATION.toString(),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(3),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                    ),
                    color: Colors.white,
                    iconSize: 42,
                    onPressed: () {
                      widget.appListener.sharedPreferences.clear();
                      widget.appListener.router.navigateTo(
                          context, Screens.LOGIN.toString(),
                          replace: true);
                    },
                  )
                ],
              ),
            ),
          ),
          Center(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              padding: EdgeInsets.all(30),
              children: [
                "Activities/Schedules",
                "Band",
                "Instrument",
                "Playing Style",
                "Contacts",
                "Admin",
                "Notes/Todo",
                "Reports"
              ].map(
                (txt) {
                  Color color = widget.appListener.primaryColor;
                  switch (txt) {
                    case "Activities/Schedules":
                      color = Color.fromRGBO(0, 77, 71, 1.0);
                      break;
                    case "Notes/Todo":
                      color = Color.fromRGBO(185, 196, 201, 1.0);
                      break;
                    case "Band":
                      color = Color.fromRGBO(185, 196, 201, 1.0);
                      break;
                    case "Instrument":
                      color = Color.fromRGBO(18, 130, 119, 1.0);
                      break;
                    case "Playing Style":
                      color = Color.fromRGBO(82, 149, 171, 1.0);
                      break;
                    case "Contacts":
                      color = Color.fromRGBO(82, 149, 171, 1.0);
                      break;
                    case "Admin":
                      color = Color.fromRGBO(18, 130, 119, 1.0);
                      break;
                    case "Reports":
                      color = Color.fromRGBO(0, 77, 71, 1.0);
                      break;
                  }
                  return GridTile(
                    child: InkWell(
                      child: Card(
                        color: color,
                        child: Center(
                          child: Text(
                            "$txt",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (txt == "Activities/Schedules")
                          widget.appListener.router.navigateTo(
                              context, Screens.ACTIVITIESLIST.toString());
                        else if (txt == "Notes/Todo")
                          widget.appListener.router.navigateTo(
                              context, Screens.NOTETODOLIST.toString());
                        else if (txt == "Band")
                          widget.appListener.router
                              .navigateTo(context, Screens.BANDLIST.toString());
                        else if (txt == "Instrument")
                          widget.appListener.router.navigateTo(
                              context, Screens.INSTRUMENTLIST.toString());
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          )
        ],
      ),
    );
  }

  @override
  DashboardPresenter get presenter => DashboardPresenter(this);
}
