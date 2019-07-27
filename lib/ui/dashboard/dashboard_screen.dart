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
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                    ),
                    color: Colors.blue,
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
                      color: Colors.green,
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
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hello",
                      style: textTheme.display1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: widget.appListener.primaryColorDark,
                      ),
                    ),
                    Text(
                      "Welcome to",
                      style: textTheme.display1.copyWith(
                        fontWeight: FontWeight.w300,
                        color: widget.appListener.primaryColorDark,
                      ),
                    )
                  ],
                ),
              ),
              Image.asset(
                'assets/images/music.png',
                height: 100,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/logo.png',
              height: 88,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(9),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              children: [
                "Activities/Schedules",
                "Band",
                "Equipment",
                "Playing Style",
                "Contacts",
                "Admin",
                "Notes/Todo",
                "Reports"
              ].map(
                (txt) {
                  Color color = widget.appListener.primaryColor;
                  String image;
                  switch (txt) {
                    case "Activities/Schedules":
                      color = Color.fromRGBO(235, 84, 99, 1.0);
                      image = 'assets/images/activities.png';
                      break;
                    case "Notes/Todo":
                      color = Color.fromRGBO(185, 196, 201, 1.0);
                      image = 'assets/images/activities.png';
                      break;
                    case "Band":
                      color = Color.fromRGBO(185, 196, 201, 1.0);
                      image = 'assets/images/band.png';
                      break;
                    case "Equipment":
                      color = Color.fromRGBO(18, 130, 119, 1.0);
                      image = 'assets/images/equipment.png';
                      break;
                    case "Playing Style":
                      color = Color.fromRGBO(82, 149, 171, 1.0);
                      image = 'assets/images/playingstyle.png';
                      break;
                    case "Contacts":
                      color = Color.fromRGBO(82, 149, 171, 1.0);
                      image = 'assets/images/contacts.png';
                      break;
                    case "Admin":
                      color = Color.fromRGBO(18, 130, 119, 1.0);
                      image = 'assets/images/admin.png';
                      break;
                    case "Reports":
                      color = Color.fromRGBO(0, 77, 71, 1.0);
                      image = 'assets/images/activities.png';
                      break;
                  }
                  return InkWell(
                    child: Card(
                      margin: EdgeInsets.all(10),
                      color: color,
                      elevation: 13,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              image,
                              height: 50,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Text(
                              "$txt",
                              textAlign: TextAlign.left,
                              style: textTheme.headline.copyWith(
                                color: Color.fromRGBO(250, 250, 250, 1.0),
                              ),
                            )
                          ],
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
                      else if (txt == "Equipment")
                        widget.appListener.router.navigateTo(
                            context, Screens.INSTRUMENTLIST.toString());
                      else if (txt == "Playing Style")
                        widget.appListener.router.navigateTo(
                            context, Screens.PLAYINGSTYLELIST.toString());
                    },
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
